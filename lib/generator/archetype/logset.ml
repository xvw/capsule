module Input = struct
  type t = { page : Raw.Input.t }

  let entity_name = "Logset"
  let neutral = Yocaml.Metadata.required entity_name

  let validate obj =
    let open Yocaml.Data.Validation in
    let+ page = Raw.Input.validate obj in
    { page }
  ;;
end

module String_map = Map.Make (String)

type state =
  { min_date : Yocaml.Datetime.t option
  ; max_date : Yocaml.Datetime.t option
  ; total_duration : Kohai_core.Duration.t
  ; sectors : Kohai_core.Duration.t String_map.t
  ; projects : Kohai_core.Duration.t String_map.t
  }

let empty_state =
  { min_date = None
  ; max_date = None
  ; total_duration = Kohai_core.Duration.zero
  ; sectors = String_map.empty
  ; projects = String_map.empty
  }
;;

type t =
  { page : Raw.Output.t
  ; logs : Kohai_model.Log.t list
  ; state : state
  }

let cmp_date f a b =
  let b = Yocaml_kohai.Datetime.to_yocaml b in
  match a with
  | None -> Some b
  | Some a -> Some (f a b)
;;

let min_date_of = cmp_date (fun a b -> if Yocaml.Datetime.(b > a) then a else b)
let max_date_of = cmp_date (fun a b -> if Yocaml.Datetime.(b < a) then a else b)

let may_add_dur duration = function
  | None -> Some duration
  | Some d -> Some (Kohai_core.Duration.add d duration)
;;

let add_duration map duration key =
  String_map.update key (may_add_dur duration) map
;;

let add_opt_duration map duration key =
  match key with
  | None -> map
  | Some key -> add_duration map duration key
;;

let update_state { min_date; max_date; total_duration; sectors; projects } log =
  let duration = Kohai_model.Log.duration log in
  let sector, project = Kohai_model.Log.sector_and_project log in
  { total_duration = Kohai_core.Duration.add total_duration duration
  ; min_date = min_date_of min_date (Kohai_model.Log.start_date log)
  ; max_date = max_date_of max_date (Kohai_model.Log.end_date log)
  ; sectors = add_duration sectors duration sector
  ; projects = add_opt_duration projects duration project
  }
;;

let compute_state logs = List.fold_left update_state empty_state logs

let normalize_indexes map =
  let open Yocaml.Data in
  map
  |> list_of (fun (k, v) ->
    record [ "key", string k; "value", Yocaml_kohai.Duration.normalize v ])
;;

let normalize
      { page
      ; logs
      ; state = { min_date; max_date; total_duration; sectors; projects }
      }
  =
  let open Yocaml.Data in
  let projects =
    String_map.to_list projects
    |> List.sort (fun (_, a) (_, b) -> Kohai_core.Duration.compare b a)
  and sectors =
    String_map.to_list sectors
    |> List.sort (fun (_, a) (_, b) -> Kohai_core.Duration.compare b a)
  and logs =
    logs
    |> List.sort (fun a b ->
      let a = Kohai_model.Log.start_date a
      and b = Kohai_model.Log.start_date b in
      Kohai_core.Datetime.compare b a)
  in
  Raw.Output.normalize page
  @ [ "logs", list_of Yocaml_kohai.Log.normalize logs
    ; "min_date", option Yocaml.Datetime.normalize min_date
    ; "max_date", option Yocaml.Datetime.normalize max_date
    ; "total_duration", Yocaml_kohai.Duration.normalize total_duration
    ; "sectors", normalize_indexes sectors
    ; "projects", normalize_indexes projects
    ; "has_logs", Model.Model_util.exists_from_list logs
    ; "has_sectors", Model.Model_util.exists_from_list sectors
    ; "has_projects", Model.Model_util.exists_from_list projects
    ]
;;

let full_configure ~config ~source ~target ~kind ~on_synopsis =
  Yocaml.Task.lift (fun ((logs, deps), (Input.{ page }, content)) ->
    let state = compute_state logs in
    let published_at = state.min_date in
    let updated_at = state.max_date in
    let meta =
      { page =
          Raw.Output.full_configure
            ?published_at
            ?updated_at
            ~config
            ~source
            ~target
            ~kind
            ~on_synopsis
            page
      ; logs
      ; state
      }
    in
    (meta, content), deps)
;;
