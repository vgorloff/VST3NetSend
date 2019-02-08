require 'ffi'

file = File.dirname(__FILE__) + '/mcAutomation.framework/mcAutomation'
if !File.exist?(file)
   file = ENV['AWL_SYS_HOME'] + '/lib/mcAutomation.framework/mcAutomation'
end

# See also: https://github.com/ffi/ffi/wiki/Examples
module AutomationProxy
   extend FFI::Library
   ffi_lib file
   attach_function :mod_prepare, [], :void
   attach_function :mod_construct, [], :pointer
   attach_function :mod_sync, [:pointer, :pointer, :int, :pointer], :void
   attach_function :mod_diff, [:pointer, :string, :string, :bool, :pointer], :void
   attach_function :xc_build, [:string, :string], :void
   attach_function :xc_clean, [:string, :string], :void
end
