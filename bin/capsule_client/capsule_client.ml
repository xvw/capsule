open Js_of_ocaml
open Nightmare_js

let () = Suspension.allow ()

let () =
  Js.export "capsule_dapps"
    (object%js
       method mountTransfer container_id =
         let id = Js.to_string container_id in
         Dapp_transfer.mount id
    end)
