open Nightmare_js

let app instance username status =
  let () = Command.register () in
  let init = Model.init instance username status in
  Lwt.return
  @@ Nightmare_js_vdom.app ~init ~update:Model.update ~view:View.view ()

let mount container_id instance username status =
  Nightmare_js_vdom.mount_to ~id:container_id (fun _ ->
      let () =
        Console.(string info) @@ "mounting Comments in #" ^ container_id
      in
      app instance username status)
