(** Describes an entrypoint of an RPC. *)

type ('meth, 'encoding, 'continuation, 'witness) t
  constraint 'meth = [< `GET | `POST | `PATCH | `DELETE ]

val get :
     path:(unit -> ('a, 'b) Path.t)
  -> 'c Data_encoding.t
  -> ([ `GET ], 'c, 'a, 'b) t

val post :
     path:(unit -> ('a, 'b) Path.t)
  -> 'c Data_encoding.t
  -> ([ `POST ], 'c, 'a, 'b) t

val patch :
     path:(unit -> ('a, 'b) Path.t)
  -> 'c Data_encoding.t
  -> ([ `PATCH ], 'c, 'a, 'b) t

val delete :
     path:(unit -> ('a, 'b) Path.t)
  -> 'c Data_encoding.t
  -> ([ `DELETE ], 'c, 'a, 'b) t

val sprintf_with : (string -> 'b) -> (_, _, 'a, 'b) t -> 'a
val sprintf : (_, _, 'a, string) t -> 'a
val make_url : Network.t -> ('a, 'b, 'c, string) t -> 'c
val method_of : ('meth, _, _, _) t -> 'meth
val encoding_of : (_, 'encoding, _, _) t -> 'encoding Data_encoding.t
