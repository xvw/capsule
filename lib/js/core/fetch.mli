(** A very small binding of Fetch API *)

open Js_of_ocaml

(** {1 types} *)

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

(** {1 Fetch Parameters} *)

val cors : [> `CORS ]
val no_cors : [> `NO_CORS ]
val same_origin : [> `SAME_ORIGIN ]
val omit : [> `OMIT ]
val include_ : [> `INCLUDE ]
val default : [> `DEFAULT ]
val no_store : [> `NO_STORE ]
val reload : [> `RELOAD ]
val no_cache : [> `NO_CACHE ]
val force_cache : [> `FORCE_CACHE ]
val only_if_cached : [> `ONLY_IF_CACHED ]
val follow : [> `FOLLOW ]
val error : [> `ERROR ]
val manual : [> `MANUAL ]
val no_referrer : [> `NO_REFERRER ]
val client : [> `CLIENT ]
val referrer : string -> [> `REFER_TO of string ]
val no_referrer_when_downgrade : [> `NO_REFERRER_WHEN_DOWNGRADE ]
val origin : [> `ORIGIN ]
val origin_when_cross_origin : [> `ORIGIN_WHEN_CROSS_ORIGIN ]
val unsafe_url : [> `UNSAFE_URL ]

(** {1 Fetch Response} *)

module Response : sig
  type t

  val headers : t -> Bindings.headers Js.t
  val ok : t -> bool
  val redirected : t -> bool
  val status : t -> int
  val type_ : t -> string
  val url : t -> string
  val text : t -> string Lwt.t

  val get_reader :
    t -> Typed_array.int8Array Js.t Bindings.readable_stream_default Js.t

  val read_body :
       Typed_array.int8Array Js.t Bindings.readable_stream_default Js.t
    -> (bool * string) Lwt.t
end

(** {1 Fetch} *)

val fetch :
     ?headers:headers
  -> ?body:request_body
  -> ?mode:mode
  -> ?cache:cache
  -> ?credentials:credentials
  -> ?redirect:redirect
  -> ?referrer:referrer
  -> ?referrer_policy:referrer_policy
  -> ?integrity:string
  -> ?keep_alive:bool
  -> method_:method_
  -> string
  -> Response.t Lwt.t

val get :
     ?headers:headers
  -> ?mode:mode
  -> ?cache:cache
  -> ?credentials:credentials
  -> ?redirect:redirect
  -> ?referrer:referrer
  -> ?referrer_policy:referrer_policy
  -> ?integrity:string
  -> ?keep_alive:bool
  -> string
  -> Response.t Lwt.t

val post :
     ?headers:headers
  -> ?body:request_body
  -> ?mode:mode
  -> ?cache:cache
  -> ?credentials:credentials
  -> ?redirect:redirect
  -> ?referrer:referrer
  -> ?referrer_policy:referrer_policy
  -> ?integrity:string
  -> ?keep_alive:bool
  -> string
  -> Response.t Lwt.t

val patch :
     ?headers:headers
  -> ?body:request_body
  -> ?mode:mode
  -> ?cache:cache
  -> ?credentials:credentials
  -> ?redirect:redirect
  -> ?referrer:referrer
  -> ?referrer_policy:referrer_policy
  -> ?integrity:string
  -> ?keep_alive:bool
  -> string
  -> Response.t Lwt.t

val delete :
     ?headers:headers
  -> ?body:request_body
  -> ?mode:mode
  -> ?cache:cache
  -> ?credentials:credentials
  -> ?redirect:redirect
  -> ?referrer:referrer
  -> ?referrer_policy:referrer_policy
  -> ?integrity:string
  -> ?keep_alive:bool
  -> string
  -> Response.t Lwt.t
