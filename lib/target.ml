open Yocaml

let md_to_html file = basename $ replace_extension file "html"
let css ~target = "css" |> into target
let javascript ~target = "js" |> into target
let fonts ~target = "fonts" |> into target
let images ~target = "images" |> into target
let pages ~target = "pages" |> into target
let indexes ~target = target
let for_page ~target file = md_to_html file |> into (pages ~target)
let for_index ~target file = md_to_html file |> into (indexes ~target)
