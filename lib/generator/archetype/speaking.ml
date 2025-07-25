module Make (P : Yocaml.Required.DATA_PROVIDER) (R : Intf.RESOLVER) = struct
  module Input = struct
    include Raw.Input

    let entity_name = "Speaking"
    let neutral = Yocaml.Metadata.required entity_name
    let validate f = validate f
  end

  module IMap = Stdlib.Map.Make (Stdlib.Int)

  let index talks =
    let i, mind, maxd, map =
      List.fold_left
        (fun (i, mindate, maxdate, map) talk ->
           let date = Talk.date_of talk in
           let year = Talk.year_of talk in
           ( succ i
           , Std.Datetime.min_opt mindate date
           , Std.Datetime.max_opt maxdate date
           , IMap.update
               year
               (function
                 | None -> Some (1, [ talk ])
                 | Some (x, xs) -> Some (succ x, talk :: xs))
               map ))
        (0, None, None, IMap.empty)
        talks
    in
    let map =
      map
      |> IMap.map (fun (i, talks) ->
        ( i
        , List.sort
            (fun a b ->
               let a = Talk.date_of a
               and b = Talk.date_of b in
               Yocaml.Datetime.compare b a)
            talks ))
    in
    i, mind, maxd, map
  ;;

  type t =
    { page : Raw.Output.t
    ; talks : (int * Talk.t list) IMap.t
    ; number_of_talks : int
    }

  let table_of_content x _ = x

  let fetch_talks on_synopsis path =
    Yocaml.Task.from_effect ~has_dynamic_dependencies:false (fun page ->
      let open Yocaml.Eff in
      let* files =
        read_directory ~on:`Source ~only:`Files ~where:File.is_markdown path
      in
      let+ talks =
        List.traverse
          (fun file ->
             let+ metadata, content =
               read_file_with_metadata (module P) (module Talk) ~on:`Source file
             in
             Talk.collapse_content metadata (on_synopsis content))
          files
      in
      let number_of_talks, mindate, maxdate, talks = index talks in
      { page =
          page
          |> Raw.Output.patch_date ?updated_at:maxdate ?published_at:mindate
      ; talks
      ; number_of_talks
      })
  ;;

  let full_configure ~config ~source ~target ~kind ~on_synopsis =
    let open Yocaml.Task in
    lift ~has_dynamic_dependencies:false (fun page ->
      Raw.Output.full_configure ~config ~source ~target ~kind ~on_synopsis page)
    >>> fetch_talks on_synopsis R.Source.talks
    |> Static.on_metadata
  ;;

  let normalize_by_year talks =
    let open Yocaml.Data in
    let talks =
      IMap.fold
        (fun year (number_of_talks, talks) xs ->
           let x =
             record
               [ "year", int year
               ; "number_of_talks", int number_of_talks
               ; "has_talks", bool (number_of_talks > 0)
               ; "talks", list_of Talk.normalize talks
               ]
           in
           x :: xs)
        talks
        []
    in
    list talks
  ;;

  let normalize { page; talks; number_of_talks } =
    let open Yocaml.Data in
    Raw.Output.normalize page
    @ [ "number_of_talks", int number_of_talks
      ; "has_talks", bool (number_of_talks > 0)
      ; "years", normalize_by_year talks
      ]
  ;;
end
