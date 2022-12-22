type ('meth, 'encoding, 'continuation, 'witness) t = {
    meth : 'meth
  ; path : unit -> ('continuation, 'witness) Path.t
  ; encoding : 'encoding Data_encoding.t
}
  constraint 'meth = [< `GET | `POST | `PATCH | `DELETE ]

let make ~method_ ~path encoding = { meth = method_; path; encoding }
let get ~path encoding = make ~method_:`GET ~path encoding
let post ~path encoding = make ~method_:`POST ~path encoding
let patch ~path encoding = make ~method_:`PATCH ~path encoding
let delete ~path encoding = make ~method_:`DELETE ~path encoding
let sprintf_with handler { path; _ } = Path.sprintf_with handler @@ path ()
let sprintf { path; _ } = Path.sprintf @@ path ()

let make_url network entrypoint =
  sprintf_with (fun path -> Network.base_path network ^ "/" ^ path) entrypoint

let method_of { meth; _ } = meth
let encoding_of { encoding; _ } = encoding
