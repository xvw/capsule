module Input = struct
  type t =
    { page : Raw.Input.t
    ; origin : Model.Url.t option
    ; portal : Model.Url.t option
    }

  let entity_name = "Translated_page"
  let neutral = Yocaml.Metadata.required entity_name
  let to_entry ~file ~url { page; _ } = Raw.Input.to_entry ~file ~url page

  let validate obj =
    let open Yocaml.Data.Validation in
    let* page = Raw.Input.validate obj in
    record
      (fun fields ->
         let+ origin = optional fields "origin" Model.Url.validate
         and+ portal = optional fields "portal" Model.Url.validate in
         { page; origin; portal })
      obj
  ;;
end

type t =
  { page : Raw.Output.t
  ; origin : Model.Url.t option
  ; portal : Model.Url.t option
  }

let normalize { page; origin; portal } =
  Raw.Output.normalize page
  @ Yocaml.Data.
      [ "origin", option Model.Url.normalize origin
      ; "portal", option Model.Url.normalize portal
      ; "has_origin", Model.Model_util.exists_from_opt origin
      ; "has_portal", Model.Model_util.exists_from_opt portal
      ]
;;

let table_of_content { page; origin; portal } s =
  { page = Raw.Output.table_of_content page s; origin; portal }
;;

let full_configure ~config ~source ~target ~kind ~on_synopsis =
  Yocaml.Task.Static.on_metadata
    (Yocaml.Task.lift
     @@ fun { Input.page; origin; portal } ->
     { page =
         Raw.Output.full_configure
           ~config
           ~source
           ~target
           ~kind
           ~on_synopsis
           page
     ; portal
     ; origin
     })
;;
