type elt =
  { id : string
  ; name : string
  ; desc : string option
  ; kv : Model.Key_value.String.t
  ; links : Model.Link.t list
  ; url : Model.Url.t
  ; url_tb : Model.Url.t option
  ; row_span : int option
  ; col_span : int option
  }

type 'a gallery =
  { page : 'a
  ; elements : elt list
  }

module Input = struct
  type t = Raw.Input.t gallery

  let entity_name = "Gallery"
  let neutral = Yocaml.Metadata.required entity_name
  let to_entry ~file ~url { page; _ } = Raw.Input.to_entry ~file ~url page

  let validate_elt =
    let open Yocaml.Data.Validation in
    record (fun fields ->
      let+ id = required fields "id" Yocaml.Slug.validate
      and+ name = required fields "name" string
      and+ desc = optional fields "desc" string
      and+ url = required fields "url" Model.Url.validate
      and+ url_tb = optional fields "url_tb" Model.Url.validate
      and+ row_span = optional fields "row_span" int
      and+ col_span = optional fields "col_span" int
      and+ links =
        optional_or ~default:[] fields "links" (list_of Model.Link.validate)
      and+ kv =
        optional_or
          ~default:Model.Key_value.String.empty
          fields
          "kv"
          Model.Key_value.String.validate
      in
      { id; name; desc; kv; links; url; url_tb; row_span; col_span })
  ;;

  let validate obj =
    let open Yocaml.Data.Validation in
    let* page = Raw.Input.validate obj in
    record
      (fun fields ->
         let+ elements =
           optional_or ~default:[] fields "elements" (list_of validate_elt)
         in
         { page; elements })
      obj
  ;;
end

type t = Raw.Output.t gallery

let normalize_span row_span col_span =
  let row =
    row_span
    |> Option.map (Format.asprintf "grid-row: span %d")
    |> Option.to_list
  in
  let col =
    col_span
    |> Option.map (Format.asprintf "grid-column: span %d")
    |> Option.to_list
  in
  row @ col
;;

let normalize_elt { id; name; desc; kv; links; url; url_tb; row_span; col_span }
  =
  let open Yocaml.Data in
  let url = Model.Url.normalize url in
  let tb = Std.Option.(Model.Url.normalize <$> url_tb || url) in
  let st = normalize_span row_span col_span in
  record
    [ "id", string id
    ; "name", string name
    ; "desc", option string desc
    ; "kv", Model.Key_value.String.normalize kv
    ; "links", (list_of Model.Link.normalize) links
    ; "row_span", option int row_span
    ; "col_span", option int col_span
    ; "url", url
    ; "url_tb", tb
    ; "style", string (String.concat "; " st)
    ; "has_desc", Model.Model_util.exists_from_opt desc
    ; "has_kv", Model.Key_value.String.has_elements kv
    ; "has_links", Model.Model_util.exists_from_list links
    ; "has_col_span", Model.Model_util.exists_from_opt col_span
    ; "has_row_span", Model.Model_util.exists_from_opt row_span
    ; "has_style", Model.Model_util.exists_from_list st
    ]
;;

let normalize { page; elements } =
  let open Yocaml.Data in
  Raw.Output.normalize page
  @ [ "number_of_elements", int @@ List.length elements
    ; "elements", list_of normalize_elt elements
    ; "has_elements", Model.Model_util.exists_from_list elements
    ]
;;

let table_of_content ({ page; _ } as gal) s =
  { gal with page = Raw.Output.table_of_content page s }
;;

let full_configure ~config ~source ~target ~kind ~on_synopsis =
  Yocaml.Task.Static.on_metadata
    (Yocaml.Task.lift
     @@ fun ({ page; _ } as gal) ->
     { gal with
       page =
         Raw.Output.full_configure
           ~config
           ~source
           ~target
           ~kind
           ~on_synopsis
           page
     })
;;
