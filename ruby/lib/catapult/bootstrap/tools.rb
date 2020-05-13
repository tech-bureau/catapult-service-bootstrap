module Catapult::Bootstrap
  class Tools
    require_relative('tools/address')
    require_relative('tools/nemesis')

    # TODO: THis should be cleaned up in directory globals

    DEFAULT_RESOURCE_DIR = '/userconfig'
    DEFAULT_BIN_DIR      = '/usr/catapult/bin'

    DEFAULT_ADDRESSES_DIR  = '/addresses'

    include Mixin::ExecuteCommand

    protected
    
    @@resource_dir = nil
    def resource_dir
      @@resource_dir ||= DEFAULT_RESOURCE_DIR
    end

    @@bin_dir = nil
    def bin_dir
      @@bin_dir ||= DEFAULT_BIN_DIR
    end

    @@addresses_dir = nil
    def addresses_dir
      @@addresses_dir ||= mkdir_p(DEFAULT_ADDRESSES_DIR)
    end

    def type 
      @type ||= self.class.to_s.split('::').last.downcase
    end

    def network
      @network ||= Global.catapult_nework_identifier
    end

    COMMAND_NAME_PREFIX = 'catapult.tools'
    def executable
      @executable ||= ret_executable(self.type)
    end

    private

    def ret_executable(tool_name)
      "#{self.bin_dir}/#{COMMAND_NAME_PREFIX}.#{tool_name}"
    end

    def mkdir_p(dir)
      ::FileUtils.mkdir_p(dir)
      dir
    end

  end
end
