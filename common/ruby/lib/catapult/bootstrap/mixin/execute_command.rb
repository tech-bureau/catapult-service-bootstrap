require 'frontkick'
require 'tempfile'

module Catapult::Bootstrap
  module Mixin
    module ExecuteCommand
      # returns stdout if no error
      def execute_command(command_string, timeout: nil)
        execute_command_all_info(command_string, timeout: timeout).stdout
      end
      
      ExecuteInfo = Struct.new(:stdout, :stderr, :status)
      def execute_command_all_info(command_string, timeout: nil)
        # Using Frontkick for timeout capability
        result = ::Frontkick.exec(command_string, timeout: timeout)
        if result.status == 0
          ExecuteInfo.new(result.stdout, result.stderr, result.status)
        else
          fail "Error on #{command_string}: #{result.stderr}"
        end
      end

      def create_tempfile(content = nil, &block)
        begin 
          is_closed = false
          temp_file = ::Tempfile.new
          if content
            temp_file << content
            temp_file.close
            is_closed = true
          end
          block.call(temp_file)
        ensure
          temp_file.close unless is_closed
          temp_file.unlink
        end
      end

    end
  end
end
