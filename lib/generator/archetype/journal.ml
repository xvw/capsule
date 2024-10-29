type 'a entry =
  { kv : Model.Key_value.String.t
  ; datetime : Yocaml.Datetime.t
  ; page : 'a
  }

let replace_datetime ~file input =
  match file |> Yocaml.Path.remove_extension |> Yocaml.Path.basename with
  | None -> input
  | Some x ->
    (match x |> Yocaml.Data.string |> Yocaml.Datetime.validate with
     | Ok datetime -> { input with datetime }
     | _ -> input)
;;

module Input = struct
  type pre =
    { cover : Model.Cover.t option
    ; tags : string list
    ; indexes : Model.Indexes.t
    }

  type t = pre entry

  let title_of { datetime; _ } =
    Format.asprintf "%a" Yocaml.Datetime.pp datetime
  ;;

  let summary_of { datetime; page = { tags; _ }; _ } =
    Format.asprintf
      "Entrée du %a, à propos de %s"
      Yocaml.Datetime.pp
      datetime
      (String.concat ", " tags)
  ;;

  let entity_name = "Journal Entry"
  let neutral = Yocaml.Metadata.required entity_name

  let validate =
    let open Yocaml.Data.Validation in
    record (fun fields ->
      let datetime = Yocaml.Datetime.dummy in
      let+ cover = optional fields "cover" Model.Cover.validate
      and+ tags =
        optional_or ~default:[] fields "tags" @@ list_of Yocaml.Slug.validate
      and+ kv =
        optional_or
          ~default:Model.Key_value.String.empty
          fields
          "kv"
          Model.Key_value.String.validate
      and+ indexes =
        optional_or
          ~default:Model.Indexes.empty
          fields
          "indexes"
          Model.Indexes.validate
      in
      let page = { cover; tags; indexes } in
      { kv; datetime; page })
  ;;

  let to_entry ~file ~url jrnl =
    let dt = replace_datetime ~file jrnl in
    let title = title_of dt in
    let summary = summary_of dt in
    Model.Entry.make
      ~title
      ~content_url:url
      ~tags:jrnl.page.tags
      ~summary
      ~file
      ~datetime:jrnl.datetime
      ()
  ;;
end

let inject_datetime ~file =
  Yocaml.Task.Static.on_metadata (Yocaml.Task.lift @@ replace_datetime ~file)
;;

type t = Raw.Output.t entry

let table_of_content i s =
  { i with page = Raw.Output.table_of_content i.page s }
;;

let normalize { kv; page; datetime } =
  Raw.Output.normalize page
  @ [ "kv", Model.Key_value.String.normalize kv
    ; "datetime", Yocaml.Datetime.normalize datetime
    ; "has_kv", Model.Key_value.String.has_elements kv
    ]
;;

let from_input ({ datetime; page = Input.{ tags; indexes; cover }; _ } as r) =
  let title = Input.title_of r in
  let synopsis = Input.summary_of r in
  let description = Some synopsis in
  let charset = Some "utf-8" in
  let published_at = Some datetime in
  let page =
    new Common.t
      ~document_kind:Model.Types.Article
      ~title
      ~cover
      ~published_at
      ~updated_at:None
      ~charset
      ~tags
      ~synopsis
      ~description
      ~display_toc:false
      ~section:(Some "journal")
      ~breadcrumb:
        [ Model.Link.make
            "Journal"
            (Model.Url.from_path (Yocaml.Path.abs [ "journal" ]))
        ]
      ~notes:[]
      ~indexes
  in
  { r with page }
;;

let full_configure ~config ~source ~target ~kind ~on_synopsis =
  let open Yocaml.Task in
  Static.on_metadata
    (lift (replace_datetime ~file:source)
     >>> lift from_input
     >>> lift
         @@ fun ({ page; _ } as entry) ->
         { entry with
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
