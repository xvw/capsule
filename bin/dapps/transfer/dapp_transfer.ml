open Nightmare_js

let app () =
  let open Dapps.Lwt_util in
  let client =
    Beacon.Dapp_client.make ~color_mode:Beacon.Color_mode.Dark
      ~preferred_network:Network.preferred_network ~name:"capsule-transfer" ()
  in
  let () = Command.register client in
  let+ init = Model.init in
  Nightmare_js_vdom.app ~init ~update:Model.update ~view:View.view ()

let mount container_id =
  Nightmare_js_vdom.mount_to ~id:container_id (fun _ ->
      let () =
        Console.(string info) @@ "mounting Transfer in #" ^ container_id
      in
      app ())
