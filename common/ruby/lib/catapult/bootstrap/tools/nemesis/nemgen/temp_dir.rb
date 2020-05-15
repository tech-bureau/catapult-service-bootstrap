module Catapult::Bootstrap
  class Tools::Nemesis::Nemgen
    class TempDir < self
      def initialize
        # dynamically set
        @temp_dir_path = nil
        @mosaics       = nil
      end
      # If generate_nemesis? called, we must always call remove
      def generate_nemesis?
        @temp_dir_path ||= generate_nemesis
      end

      def remove_temp_dir
        if self.temp_dir_path?
          ::FileUtils.rm_rf self.temp_dir_path?
        end
      end

      def generate_nemesis
        @temp_dir_path = ::Dir.mktmpdir
        begin
          mkdir_data_dir_00000
          create_hashes_dat_file
          execute_nemgen(@temp_dir_path)
          @temp_dir_path
        rescue => e
          STDERR << e.inspect
          remove_temp_dir
          nil
        end
      end
      private :generate_nemesis

      # two pases to get and then set the mosaics
      def execute_nemgen(temp_dir_path)
        ::Dir.chdir(temp_dir_path) do 
          execute_info = execute_command_all_info(self.nemgen_command)
          @mosaics = Mosaics.parse(execute_info.stderr)
          @mosaics.update_config_network_file(self.component_userconfig_dir)
          execute_command(self.nemgen_command)
        end
      end
      private :execute_nemgen

      def seed_dir
        @seed_dir ||= "#{self.temp_dir_path}/#{Config::Nemesis::BlockPropertiesFile.bin_directory}"
      end

      def mosaics
        @mosaics || fail("@mosaics is nil")
      end
      
      protected

      def temp_dir_path
        self.temp_dir_path? || fail("temp_dir_path should be set")
      end

      def temp_dir_path?
        @temp_dir_path 
      end

      def data_dir_00000
        @data_dir_00000 ||= "#{seed_dir}/00000"
      end

      def nemgen_command
        @nemgen_command ||= "#{ret_executable(:nemgen)} -r  #{self.component_userconfig_dir} --nemesisProperties #{self.block_properties_path}"
      end

      private

      def mkdir_data_dir_00000
        ::FileUtils.mkdir_p self.data_dir_00000
      end

      def create_hashes_dat_file
        execute_command("dd if=/dev/zero of=#{self.data_dir_00000}/hashes.dat bs=1 count=64")
      end
      
    end
  end
end
