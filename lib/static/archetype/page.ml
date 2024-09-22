module Parse = struct
  class type t = Model.Types.common

  let entity_name = "Page"
  let neutral = Yocaml.Metadata.required entity_name

  let validate =
    let open Yocaml.Data.Validation in
    record Model.Common.validate
  ;;
end

class type t = object
  inherit Parse.t
  inherit Model.Types.with_configuration
end

class make p config =
  object (_ : #t)
    inherit
      Model.Common.t
        ~title:p#page_title
        ~charset:p#page_charset
        ~description:p#description
        ~tags:p#tags
        ~display_toc:p#display_toc

    method configuration = config
  end

let configure config =
  Yocaml.Task.Static.on_metadata
    (Yocaml.Task.lift (fun parsed -> new make parsed config))
;;

let table_of_contents page = page#with_toc

let normalize page =
  Model.Common.normalize page
  @ [ "configuration", Model.Config.normalize page#configuration ]
;;
