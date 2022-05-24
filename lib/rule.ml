open Yocaml

let css ~target =
  process_files
  $ [ "css" ]
  $ File.is_css
  $ Build.copy_file ~into:("css" |> into target)

let javascript ~target =
  process_files
  $ [ "js" ]
  $ File.is_javascript
  $ Build.copy_file ~into:("js" |> into target)

let fonts ~target =
  process_files
  $ [ "fonts" ]
  $ File.is_font
  $ Build.copy_file ~into:("fonts" |> into target)

let images ~target =
  process_files
  $ [ "images" ]
  $ File.is_image
  $ Build.copy_file ~into:("images" |> into target)

let static ~target =
  let open Effect in
  let* () = css ~target in
  let* () = javascript ~target in
  let* () = fonts ~target in
  let* () = images ~target in
  return ()
