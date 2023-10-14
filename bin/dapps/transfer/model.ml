type trace = Pending of string | Error of string | Done of string

type sync_state = {
    account : Beacon.Account_info.t
  ; balance : Yourbones.tez
  ; head : Yourbones.Block_header.t option
  ; benefactor_address :
      (Yourbones.Address.t, Yourbones.Address.error) Dapps.Inputable.t
}

type state = Not_synced | Synced of sync_state | Loading
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
      { account; balance; head; benefactor_address = Dapps.Inputable.empty () }
  in
  { trace; state }

let loading ?(trace = []) () = { trace; state = Loading }
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
        Dapps.Inputable.set_value Yourbones.Address.from_string value
      in
      let new_trace =
        Option.bind (Dapps.Inputable.repr benefactor_address) (function
          | Error _ -> Some (`Override [ error "L'adresse est invalide" ])
          | Ok address ->
              if Yourbones.Address.equal address state.account.address then
                Some
                  (`Override
                    [ error "L'adresse doit être différente de la vôtre" ])
              else None)
      in
      Vdom.return
      @@ sync_lense ?new_trace model (fun sync_state ->
             Synced { sync_state with benefactor_address })
  | _ -> Vdom.return model

let update model message =
  match message with
  | Message.With_error err ->
      Vdom.return { model with trace = error err :: model.trace }
  | message -> (
      match model.state with
      | Not_synced -> update_not_synced model message
      | Loading -> update_loading model message
      | Synced state -> update_synced model state message)
