open Js_of_ocaml

type headers = Bindings.headers Js.t
type request_body = Bindings.a_body Js.t
type method_ = [ `GET | `POST | `PATCH | `DELETE ]
type mode = [ `CORS | `NO_CORS | `SAME_ORIGIN ]
type credentials = [ `OMIT | `SAME_ORIGIN | `INCLUDE ]

type cache =
  [ `DEFAULT | `NO_STORE | `RELOAD | `NO_CACHE | `FORCE_CACHE | `ONLY_IF_CACHED ]

type redirect = [ `FOLLOW | `ERROR | `MANUAL ]
type referrer = [ `NO_REFERRER | `CLIENT | `REFER_TO of string ]

type referrer_policy =
  [ `NO_REFERRER
  | `NO_REFERRER_WHEN_DOWNGRADE
  | `ORIGIN
  | `ORIGIN_WHEN_CROSS_ORIGIN
  | `UNSAFE_URL ]

let cors = `CORS
let no_cors = `NO_CORS
let same_origin = `SAME_ORIGIN
let omit = `OMIT
let include_ = `INCLUDE
let default = `DEFAULT
let no_store = `NO_STORE
let reload = `RELOAD
let no_cache = `NO_CACHE
let force_cache = `FORCE_CACHE
let only_if_cached = `ONLY_IF_CACHED
let follow = `FOLLOW
let error = `ERROR
let manual = `MANUAL
let no_referrer = `NO_REFERRER
let client = `CLIENT
let referrer s = `REFER_TO s
let no_referrer_when_downgrade = `NO_REFERRER_WHEN_DOWNGRADE
let origin = `ORIGIN
let origin_when_cross_origin = `ORIGIN_WHEN_CROSS_ORIGIN
let unsafe_url = `UNSAFE_URL

let method_to_string = function
  | `GET -> "GET"
  | `POST -> "POST"
  | `PATCH -> "PATCH"
  | `DELETE -> "DELETE"

let mode_to_string = function
  | `CORS -> "cors"
  | `NO_CORS -> "no-cors"
  | `SAME_ORIGIN -> "same-origin"

let credentials_to_string = function
  | `OMIT -> "omit"
  | `SAME_ORIGIN -> "same-origin"
  | `INCLUDE -> "include"

let cache_to_string = function
  | `DEFAULT -> "default"
  | `NO_STORE -> "no-store"
  | `RELOAD -> "reload"
  | `NO_CACHE -> "no-cache"
  | `FORCE_CACHE -> "force-cache"
  | `ONLY_IF_CACHED -> "only-if-cached"

let redirect_to_string = function
  | `FOLLOW -> "follow"
  | `ERROR -> "error"
  | `MANUAL -> "manual"

let referrer_to_string = function
  | `NO_REFERRER -> "no-referrer"
  | `CLIENT -> "client"
  | `REFER_TO x -> x

let referrer_policy_to_string = function
  | `NO_REFERRER -> "no-referrer"
  | `NO_REFERRER_WHEN_DOWNGRADE -> "no-referrer-when-downgrade"
  | `ORIGIN -> "origin"
  | `ORIGIN_WHEN_CROSS_ORIGIN -> "origin-when-cross-origin"
  | `UNSAFE_URL -> "unsafe-url"

let make_init ?headers ?body ?mode ?cache ?credentials ?redirect ?referrer
    ?referrer_policy ?integrity ?keep_alive ~method_ () :
    Bindings.fetch_init Js.t =
  let open Undefinedable_stubs in
  object%js
    val _method = Js.string @@ method_to_string method_
    val headers = from_option headers
    val body : Bindings.a_body Js.t Js.optdef = from_option body
    val mode = Util.(Js.string % mode_to_string) <$> from_option mode

    val credentials =
      Util.(Js.string % credentials_to_string) <$> from_option credentials

    val cache = Util.(Js.string % cache_to_string) <$> from_option cache

    val redirect =
      Util.(Js.string % redirect_to_string) <$> from_option redirect

    val referrer =
      Util.(Js.string % referrer_to_string) <$> from_option referrer

    val referrerPolicy =
      Util.(Js.string % referrer_policy_to_string)
      <$> from_option referrer_policy

    val integrity = Js.string <$> from_option integrity
    val keepalive = Js.bool <$> from_option keep_alive
  end

module Response = struct
  type t = Bindings.fetch_response Js.t

  let headers resp = resp##.headers
  let ok resp = resp##.ok |> Js.to_bool
  let redirected resp = resp##.redirected |> Js.to_bool
  let status resp = resp##.status
  let type_ resp = resp##._type |> Js.to_string
  let url resp = resp##.url |> Js.to_string

  let text resp =
    let open Lwt.Syntax in
    let+ txt = resp##text |> Util.as_lwt in
    Js.to_string txt

  let get_reader resp = resp##.body##getReader

  let read_body resp =
    let reader = get_reader resp in
    let open Lwt.Syntax in
    let+ result = reader##read |> Util.as_lwt in
    let decoder = Text_decoder.make () in
    (result##.done_ |> Js.to_bool, Text_decoder.decode decoder result##.value)
end

let fetch_handler (s : Js.js_string Js.t) (init : Bindings.fetch_init Js.t) :
    Response.t Util.promise =
  Js.Unsafe.fun_call
    (Js.Unsafe.js_expr "fetch")
    [| Js.Unsafe.inject s; Js.Unsafe.inject init |]

let fetch ?headers ?body ?mode ?cache ?credentials ?redirect ?referrer
    ?referrer_policy ?integrity ?keep_alive ~method_ target =
  let init =
    make_init ?headers ?body ?mode ?cache ?credentials ?redirect ?referrer
      ?referrer_policy ?integrity ?keep_alive ~method_ ()
  in
  fetch_handler (Js.string target) init |> Util.as_lwt

let get = fetch ~method_:`GET ?body:None
let post = fetch ~method_:`POST
let patch = fetch ~method_:`PATCH
let delete = fetch ~method_:`DELETE
