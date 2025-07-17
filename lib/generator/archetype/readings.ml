module Make (P : Yocaml.Required.DATA_PROVIDER) (R : Intf.RESOLVER) = struct
  module Input = struct
    include Raw.Input

    let entity_name = "Readings"
    let neutral = Yocaml.Metadata.required entity_name
    let validate f = validate f
  end

  (* module Books = struct *)
  (*   include Model.Key_value.By_string (Model.Book) *)

  (*   let entity_name = "Books" *)
  (*   let neutral = Ok empty *)
  (* end *)

  (* module Readings = struct *)
  (*   type t = Model.Reading.t list *)

  (*   let entity_name = "Readings" *)
  (*   let neutral = Ok [] *)
  (*   let validate = Yocaml.Data.Validation.list_of Model.Reading.validate *)
  (* end *)

  (* let index = *)
  (*   let open Yocaml in *)
  (*   let open Task.Infix in *)
  (*   Pipeline.read_file_as_metadata (module P) (module Books) R.Source.books *)
  (*   &&& Pipeline.read_file_as_metadata *)
  (*         (module P) *)
  (*         (module Readings) *)
  (*         R.Source.readings_list *)
  (*   >>| fun (books, readings) -> assert false *)
  (* ;; *)

  type t

  let table_of_content x _ = x

  let full_configure ~config:_ ~source:_ ~target:_ ~kind:_ ~on_synopsis:_ =
    assert false
  ;;

  let normalize _ = assert false
end
