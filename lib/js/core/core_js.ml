module Core_bindings = Bindings
module Aliases = Aliases
module Interfaces = Interfaces
module Option = Option_stubs
module Nullable = Nullable_stubs
module Result = Result_stubs
module Undefinedable = Undefinedable_stubs
module Console = Console

type +'a or_null = 'a Aliases.or_null
type +'a or_undefined = 'a Aliases.or_undefined

module Storage = struct
  module Local = Local_storage
  module Session = Session_storage
end

module Headers = Headers
module Form_data = Form_data
module Url_search_params = Url_search_params
module Fetch = Fetch
module Lwt_util = Lwt_util
module Util = Util
include Util
