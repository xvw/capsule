module Make (P : Yocaml.Required.DATA_PROVIDER) (R : Intf.RESOLVER) = struct
  module Input = struct
    include Raw.Input

    let entity_name = "Readings"
    let neutral = Yocaml.Metadata.required entity_name
    let validate f = validate f
  end

  module IMap = Stdlib.Map.Make (Stdlib.Int)

  module Books = struct
    include Model.Key_value.By_string (Model.Book)

    let entity_name = "Books"
    let neutral = Ok empty
  end

  module Readings = struct
    type t = Model.Reading.t list

    let entity_name = "Readings"
    let neutral = Ok []
    let validate = Yocaml.Data.Validation.list_of Model.Reading.validate
  end

  let index =
    let open Yocaml in
    let open Task.Infix in
    Pipeline.read_file_as_metadata (module P) (module Books) R.Source.books
    &&& Pipeline.read_file_as_metadata
          (module P)
          (module Readings)
          R.Source.readings_list
    >>| (fun (books, readings) ->
    List.fold_left
      (fun ((i, mindate, maxdate), map) reading ->
         let book = Model.Reading.book_of reading
         and date = Model.Reading.date_of reading
         and year = Model.Reading.year_of reading in
         match Books.find books book with
         | Some book ->
           let elt = book, reading in
           ( ( succ i
             , Std.Datetime.min_opt mindate date
             , Std.Datetime.max_opt maxdate date )
           , IMap.update
               (year :> int)
               (function
                 | None -> Some (1, [ elt ])
                 | Some (x, xs) -> Some (succ x, elt :: xs))
               map )
         | None -> (i, mindate, maxdate), map)
      ((0, None, None), IMap.empty)
      readings)
    >>> Task.(
          second
          @@ lift
               (IMap.map (fun (i, elts) ->
                  ( i
                  , List.sort
                      (fun (_, a) (_, b) ->
                         let a = Model.Reading.date_of a
                         and b = Model.Reading.date_of b in
                         Yocaml.Datetime.compare b a)
                      elts ))))
  ;;

  type t =
    { page : Raw.Output.t
    ; readings : (int * (Model.Book.t * Model.Reading.t) list) IMap.t
    ; number_of_readings : int
    }

  let table_of_content x _ = x

  let full_configure ~config ~source ~target ~kind ~on_synopsis =
    let open Yocaml.Task in
    lift (Raw.Output.full_configure ~config ~source ~target ~kind ~on_synopsis)
    >>| (fun page -> page, ())
    >>> second index
    >>| (fun (page, ((number_of_readings, published_at, updated_at), readings)) ->
    { page = page |> Raw.Output.patch_date ?published_at ?updated_at
    ; number_of_readings
    ; readings
    })
    |> Static.on_metadata
  ;;

  let normalize_by_year readings =
    let open Yocaml.Data in
    let readings =
      IMap.fold
        (fun year (number_of_readings, elts) xs ->
           let x =
             record
               [ "year", int year
               ; "number_of_readings", int number_of_readings
               ; "has_readings", bool (number_of_readings > 0)
               ; ( "readings"
                 , list_of
                     (fun (book, reading) ->
                        record
                          [ "book", Model.Book.normalize book
                          ; "reading", Model.Reading.normalize reading
                          ])
                     elts )
               ]
           in
           x :: xs)
        readings
        []
    in
    list readings
  ;;

  let normalize { page; number_of_readings; readings } =
    let open Yocaml.Data in
    Raw.Output.normalize page
    @ [ "number_of_readings", int number_of_readings
      ; "has_readings", bool (number_of_readings > 0)
      ; "years", normalize_by_year readings
      ]
  ;;
end
