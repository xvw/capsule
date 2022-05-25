open Yocaml

let css ~target = "css" |> into target
let javascript ~target = "js" |> into target
let fonts ~target = "fonts" |> into target
let images ~target = "images" |> into target
let pages ~target = "pages" |> into target

let for_page ~target file =
  let filename = basename $ replace_extension file "html" in
  filename |> into (pages ~target)
