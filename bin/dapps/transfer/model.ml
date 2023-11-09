type trace = Pending of string | Error of string | Done of string

type sync_state = {
    account : Beacon.Account_info.t
  ; balance : Yourbones.tez
  ; head : Yourbones.Block_header.t option
  ; benefactor_address :
      ( Yourbones.Address.t
      , [ Yourbones.Address.error | `Same_address ] )
      Dapps.Inputable.t
  ; amount :
      ( Yourbones.Tez.t
      , [ Yourbones.Tez.error | `Invalid_amount ] )
      Dapps.Inputable.t
}

type state =
  | Not_synced
  | Synced of sync_state
  | Await_inclusion of (sync_state * int)
  | Loading

type t = { state : state; trace : trace list }

let sync_lense ?new_trace ({ state; trace } as model) f =
  let trace =
    Option.fold ~none:trace
      ~some:(function
        | `Push x -> x @ trace | `Join x -> trace @ x | `Override x -> x)
      new_trace
  in
  match state with
  | Synced sync_state -> { state = f sync_state; trace }
  | _ -> model

let not_connected ?(trace = []) () = { trace; state = Not_synced }

let connected ?(trace = []) ?head ~account ~balance () =
  let state =
    Synced
      {
        account
      ; balance
      ; head
      ; benefactor_address = Dapps.Inputable.empty ()
      ; amount = Dapps.Inputable.empty ()
      }
  in
  { trace; state }

let loading ?(trace = []) () = { trace; state = Loading }

let await ?(trace = []) sync_state =
  {
    trace
  ; state =
      Await_inclusion
        ( {
            sync_state with
            benefactor_address = Dapps.Inputable.empty ()
          ; amount = Dapps.Inputable.empty ()
          }
        , 0 )
  }

let init = Vdom.return (not_connected ()) |> Lwt.return
let pending str = Pending str
let error str = Error str
let done_ str = Done str

let update_not_synced model = function
  | Message.Ask_for_sync ->
      Vdom.return ~c:[ Message.perform_sync ]
      @@ loading ~trace:[ pending "Attente de la synchronisation ..." ] ()
  | _ -> Vdom.return model

let update_loading model = function
  | Message.Synced_wallet { account; balance } ->
      Vdom.return ~c:[ Message.stream_head account ]
      @@ connected ~trace:[ done_ "Wallet synchronisé" ] ~account ~balance ()
  | Message.Unsynced_wallet ->
      Vdom.return @@ not_connected ~trace:[ done_ "Wallet désynchronisé" ] ()
  | _ -> Vdom.return model

let recompute_trace target amount =
  let target =
    match Dapps.Inputable.repr target with
    | None -> []
    | Some (Ok _) -> [ done_ "L'adresse cible est valide" ]
    | Some (Error `Same_address) ->
        [ error "L'adresse cible doit être différente de l'adresse source" ]
    | Some (Error _) -> [ error "L'adresse est invalide" ]
  in
  let amount =
    match Dapps.Inputable.repr amount with
    | None -> []
    | Some (Ok _) -> [ done_ "Le montant est valide" ]
    | Some (Error `Invalid_amount) ->
        [ error "Le montant est trop élevé par rapport à votre balance" ]
    | Some (Error _) -> [ error "Le montant est invalide" ]
  in
  Some (`Override (target @ amount))

let update_synced model state = function
  | Message.Ask_for_unsync ->
      Vdom.return ~c:[ Message.perform_unsync ]
      @@ loading ~trace:[ pending "Attente de la désynchronisation ..." ] ()
  | Message.New_head { new_balance; new_head } ->
      Vdom.return
      @@ sync_lense model (fun sync_state ->
             Synced
               { sync_state with head = Some new_head; balance = new_balance })
  | Message.Fill_benefactor_address value ->
      let benefactor_address =
        Dapps.Inputable.set_value
          (fun x ->
            Result.bind (Yourbones.Address.from_string x) (fun address ->
                if Yourbones.Address.equal address state.account.address then
                  Error `Same_address
                else Ok address))
          value
      in
      let new_trace = recompute_trace benefactor_address state.amount in
      Vdom.return
      @@ sync_lense ?new_trace model (fun sync_state ->
             Synced { sync_state with benefactor_address })
  | Message.Fill_amount value ->
      let balance = state.balance in
      let amount =
        Dapps.Inputable.set_value
          (fun x ->
            Result.bind (Yourbones.Tez.from_string x) (fun amount ->
                Result.bind
                  Yourbones.Tez.(balance - 1t)
                  (fun balance_bound ->
                    if Yourbones.Tez.(balance_bound <= amount) then
                      Error `Invalid_amount
                    else Ok amount)))
          value
      in

      let new_trace = recompute_trace state.benefactor_address amount in
      Vdom.return
      @@ sync_lense ?new_trace model (fun sync_state ->
             Synced { sync_state with amount })
  | Message.Transfer -> (
      let s =
        let open Preface.Option.Monad in
        let* target = Dapps.Inputable.get_result state.benefactor_address in
        let+ amount = Dapps.Inputable.get_result state.amount in
        (target, amount)
      in
      match s with
      | None -> Vdom.return model
      | Some (target, amount) ->
          let () = Nightmare_js.Console.(string log) "Performing transfer" in
          Vdom.return
            ~c:
              [
                Command.perform_transfer ~target ~amount
                  ~on_success:(fun ~target:_ ~amount:_ _ ->
                    let () =
                      Nightmare_js.Console.(string log) "Transfer done"
                    in
                    Message.Synced_transfer)
              ]
          @@ await
               ~trace:[ pending "Attente de l'inclusion du transfert ..." ]
               state)
  | _ -> Vdom.return model

let update_await model state counter = function
  | Message.New_head _ as message ->
      if counter = 1 then
        let new_state = Synced state in
        let model = { trace = []; state = new_state } in
        update_synced model state message
      else Vdom.return { model with state = Await_inclusion (state, 1) }
  | _ -> Vdom.return model

let update model message =
  match message with
  | Message.With_error err ->
      Vdom.return { model with trace = error err :: model.trace }
  | message -> (
      match model.state with
      | Not_synced -> update_not_synced model message
      | Loading -> update_loading model message
      | Synced state -> update_synced model state message
      | Await_inclusion (state, counter) ->
          update_await model state counter message)
