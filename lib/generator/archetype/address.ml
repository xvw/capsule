type 'a addr =
  { page : 'a
  ; country : string
  ; city : string
  ; zipcode : string
  ; address : string
  }

module Input = struct
  type t = Raw.Input.t addr

  let entity_name = "Address"
  let neutral = Yocaml.Metadata.required entity_name
  let to_entry ~file ~url { page; _ } = Raw.Input.to_entry ~file ~url page

  let validate obj =
    let open Yocaml.Data.Validation in
    let* page = Raw.Input.validate obj in
    record
      (fun fields ->
        let+ country = required fields "country" string
        and+ city = required fields "city" string
        and+ zipcode = required fields "zipcode" string
        and+ address = required fields "address" string in
        { page; country; city; zipcode; address })
      obj
  ;;
end

type t = Raw.Output.t addr

let uri_address country city zipcode address =
  let address = Yocaml.Slug.from ~separator:'+' address
  and country = Yocaml.Slug.from ~separator:'+' country
  and zipcode = Yocaml.Slug.from ~separator:'+' zipcode
  and city = Yocaml.Slug.from ~separator:'+' city in
  Format.asprintf
    "street=%s&city=%s&country=%s&postalcode=%s"
    address
    city
    country
    zipcode
;;

let normalize { page; country; city; zipcode; address } =
  let open Yocaml.Data in
  Raw.Output.normalize page
  @ [ "country", string country
    ; "city", string city
    ; "zipcode", string zipcode
    ; "address", string address
    ; "address_uri", string @@ uri_address country city zipcode address
    ]
;;

let table_of_content ({ page; _ } as addr) s =
  { addr with page = Raw.Output.table_of_content page s }
;;

let full_configure ~config ~source ~target ~kind ~on_synopsis =
  Yocaml.Task.Static.on_metadata
    (Yocaml.Task.lift
     @@ fun ({ page; _ } as addr) ->
     { addr with
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
