open Js_of_ocaml
open Js
open Aliases

class type console_hook =
  object
    inherit Firebug.console
    method clear : unit meth
    method count : js_string t or_undefined -> unit meth
    method countReset : js_string t or_undefined -> unit meth
    method timeLog : 'a. js_string t or_undefined -> 'a -> unit meth
    method table : 'a. 'a -> js_string t js_array t or_undefined -> unit meth
  end

external get_console : unit -> console_hook t = "caml_js_get_console"

let console = get_console ()
let assert_ x = console##assert_ x
let assert_with_message x y = console##assert_1 x y
let assert_with_message_and_payload x y z = console##assert_2 x y z
let log x = console##log x
let debug x = console##debug x
let info x = console##info x
let warn x = console##warn x
let error x = console##error x
let dir x = console##dir x
let dir_xml x = console##dirxml x
let trace () = console##trace
\
