module Aliases = Aliases
module Interfaces = Interfaces
module Option = Option_stubs
module Nullable = Nullable_stubs
module Undefinedable = Undefinedable_stubs
module Console = Console

type +'a or_null = 'a Aliases.or_null
type +'a or_undefined = 'a Aliases.or_undefined

module Storage = struct
  module Local = Local_storage
  module Session = Session_storage
end

include Util
