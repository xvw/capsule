open Js_of_ocaml
module Lwt_js_events = Js_of_ocaml_lwt.Lwt_js_events

let start f =
  let open Lwt.Syntax in
  let* _ = Lwt_js_events.onload () in
  let+ () = f () in
  ()

let () =
  let api =
    object%js (self)
      val internal =
        object%js
          val suspending = Js.array [| Hljs_js.mount |]
        end

      method suspend f =
        let _ = self##.internal##.suspending##push f in
        ()

      val dapps =
        object%js
          val transfer = Dapp_transfer.entrypoint
        end

      method mount =
        let suspension =
          self##.internal##.suspending
          |> Js.to_array
          |> Array.fold_left
               (fun continuation task () ->
                 let open Lwt.Syntax in
                 let+ () = continuation () in
                 Js.Unsafe.fun_call task [||])
               (fun () -> Lwt.return_unit)
        in
        start suspension
    end
  in
  Js.export "capsule" api
