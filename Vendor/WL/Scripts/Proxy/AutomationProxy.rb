require 'ffi'
require_relative '../Core/Archive.rb'

class AutomationHelper
   def self.fwPath
      archive = File.dirname(__FILE__) + '/mcAutomation.framework.zip'
      if !File.exist?(archive)
         path = ENV['AWL_SYS_HOME'] + '/lib/mcAutomation.framework/mcAutomation'
      else
         Archive.unzip(archive)
         path = File.dirname(__FILE__) + '/mcAutomation.framework/mcAutomation'
      end
      return path
   end
end

# See also: https://github.com/ffi/ffi/wiki/Examples
module AutomationProxy
   extend FFI::Library

   ffi_lib AutomationHelper.fwPath
   attach_function :mod_prepare, [], :void
   attach_function :mod_construct, [], :pointer
   attach_function :mod_sync, [:pointer, :pointer, :int, :pointer], :void
   attach_function :mod_diff, [:pointer, :string, :string, :bool, :pointer], :void
   attach_function :xc_build, [:string, :string], :void
   attach_function :xc_clean, [:string, :string], :void
end
