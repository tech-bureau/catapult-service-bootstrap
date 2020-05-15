module Catapult::Bootstrap
  class Tools
    require_relative('tools/address')
    require_relative('tools/nemesis')

    DEFAULT_BIN_DIR = '/usr/catapult/bin'

    include Mixin::ExecuteCommand

    protected
    
    @@bin_dir = nil
    def bin_dir
      @@bin_dir ||= DEFAULT_BIN_DIR
    end

    def type 
      @type ||= self.class.to_s.split('::').last.downcase
    end

    COMMAND_NAME_PREFIX = 'catapult.tools'
    def executable
      @executable ||= ret_executable(self.type)
    end

    private

    def ret_executable(tool_name)
      "#{self.bin_dir}/#{COMMAND_NAME_PREFIX}.#{tool_name}"
    end

  end
end
