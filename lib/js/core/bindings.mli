open Js_of_ocaml
open Js
open Aliases

class type a_body = object end

class type headers =
  object
    method append : js_string t -> js_string t -> unit meth
    method delete : js_string t -> unit meth
    method get : js_string t -> js_string t opt meth
    method has : js_string t -> bool t meth
    method set : js_string t -> js_string t -> unit meth
  end

class type form_data =
  object
    inherit a_body
    inherit headers
    method getAll : js_string t -> js_string t js_array t meth
  end

class type url_search_params =
  object
    inherit form_data
    method toString : js_string t meth
    method sort : unit meth
  end

class type uvstring =
  object
    inherit a_body
    inherit js_string
  end

class type fetch_init =
  object
    method _method : js_string t readonly_prop
    method headers : headers t optdef readonly_prop
    method body : a_body t optdef readonly_prop (* Blob is missing but...*)
    method mode : js_string t optdef readonly_prop
    method credentials : js_string t optdef readonly_prop
    method cache : js_string t optdef readonly_prop
    method redirect : js_string t optdef readonly_prop
    method referrer : js_string t optdef readonly_prop
    method referrerPolicy : js_string t optdef readonly_prop
    method integrity : js_string t optdef readonly_prop
    method keepalive : bool t optdef readonly_prop
  end

class type ['a] readable_stream_result =
  object
    method done_ : bool t readonly_prop
    method value : 'a readonly_prop
  end

class type ['a] readable_stream_default =
  object
    method closed : unit promise readonly_prop
    method cancel : unit promise meth
    method read : 'a readable_stream_result t promise meth
    method releaseLock : unit meth
  end

class type ['a] readable_stream =
  object
    method locked : bool t readonly_prop
    method cancel : unit promise meth
    method getReader : 'a readable_stream_default t meth
  end

class type fetch_response =
  object
    method headers : headers t readonly_prop
    method ok : bool t readonly_prop
    method redirected : bool t readonly_prop
    method status : int readonly_prop
    method _type : js_string t readonly_prop
    method url : js_string t readonly_prop
    method body : Typed_array.int8Array t readable_stream t readonly_prop
    method text : js_string t Util.promise meth
  end

class type text_decoder =
  object
    method encoding : js_string t readonly_prop
    method fatal : bool t readonly_prop
    method ignoreBOM : bool t readonly_prop
    method decode : Typed_array.int8Array t -> js_string t meth
  end
