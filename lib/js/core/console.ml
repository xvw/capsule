open Js_of_ocaml
open Js
open Aliases

class type console_hook =
  object
    inherit Firebug.console
    method clear : unit meth
    method count : js_string t or_undefined -> unit meth
    method countReset : js_string t or_undefined -> unit meth
    method timeLog : 'a. js_string t -> 'a -> unit meth
    method table : 'a. 'a -> js_string t js_array t or_undefined -> unit meth
  end

external get_console : unit -> console_hook t = "caml_js_get_console"

let console = get_console ()

let assertion ?message ?payload x =
  match (Option.map Js.string message, payload) with
  | Some m, Some p -> console##assert_2 x m p
  | Some m, None -> console##assert_1 x m
  | None, Some p -> console##assert_1 x p
  | None, None -> console##assert_ x

let log x = console##log x
let debug x = console##debug x
let info x = console##info x
let warn x = console##warn x
let error x = console##error x
let dir x = console##dir x
let dir_xml x = console##dirxml x
let trace () = console##trace
let message f x = f (Js.string x)

let table ?columns obj =
  let cols = Optdef.(map @@ option columns) @@ Util.list_to_js_array string in
  console##table obj cols

let time ?(label = "default") () =
  let lbl = Js.string label in
  console##time lbl

let time_log ?(label = "default") obj =
  let lbl = Js.string label in
  console##timeLog lbl obj

let time_end ?(label = "default") () =
  let lbl = Js.string label in
  console##timeEnd lbl

let count ?label () =
  let lbl = Optdef.option (Option.map string label) in
  console##count lbl

let count_reset ?label () =
  let lbl = Optdef.option (Option.map string label) in
  console##countReset lbl

let group ?(collapsed = false) ?label () =
  let lbl = Optdef.option (Option.map string label) in
  if collapsed then console##groupCollapsed lbl else console##group lbl

let group_end () = console##groupEnd
