type 'a entry =
  { meta : Model.Key_value.String.t
  ; datetime : Yocaml.Datetime.t
  ; page : 'a
  }

module Input = struct
  type t = Raw.Input.t entry

  let title_of datetime =
    Format.asprintf "Entrée du journal du %a" Yocaml.Datetime.pp datetime
  ;;

  let to_raw_input cover tags indexes datetime =
    let title = title_of datetime in
    let description = Some title in
    let synopsis = title ^ " avec traitant de " ^ String.concat ", " tags in
    new Common.t
      ~document_kind:Model.Types.Article
      ~title
      ~cover
      ~published_at:(Some datetime)
      ~updated_at:None
      ~charset:None
      ~tags
      ~synopsis
      ~description
      ~display_toc:false
      ~section:(Some "journal")
      ~breadcrumb:
        [ Model.Link.make
            "Journal"
            (Model.Url.from_path (Yocaml.Path.abs [ "journal.html" ]))
        ]
      ~notes:[]
      ~indexes
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
      and+ meta =
        optional_or
          ~default:Model.Key_value.String.empty
          fields
          "meta"
          Model.Key_value.String.validate
      and+ indexes =
        optional_or
          ~default:Model.Indexes.empty
          fields
          "indexes"
          Model.Indexes.validate
      in
      let page = to_raw_input cover tags indexes datetime in
      { meta; datetime; page })
  ;;

  let to_entry ~file ~url { page; _ } = Raw.Input.to_entry ~file ~url page
end

let replace_datetime ~file input =
  match file |> Yocaml.Path.remove_extension |> Yocaml.Path.basename with
  | None -> input
  | Some x ->
    (match x |> Yocaml.Data.string |> Yocaml.Datetime.validate with
     | Ok datetime -> { input with datetime }
     | _ -> input)
;;

let inject_datetime ~file =
  Yocaml.Task.Static.on_metadata (Yocaml.Task.lift @@ replace_datetime ~file)
;;

type t = Raw.Output.t entry

let table_of_content i s =
  { i with page = Raw.Output.table_of_content i.page s }
;;

let normalize { meta; page; datetime } =
  Raw.Output.normalize page
  @ [ "meta", Model.Key_value.String.normalize meta
    ; "datetime", Yocaml.Datetime.normalize datetime
    ]
;;

let full_configure ~config ~source ~target ~kind ~on_synopsis =
  Yocaml.Task.Static.on_metadata
    (Yocaml.Task.lift
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
