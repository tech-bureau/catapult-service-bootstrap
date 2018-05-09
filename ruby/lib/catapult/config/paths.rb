class Catapult::Config
  module Paths
    module ClassMixin
      # This method could be overwritten
      def config_info_dir
        check_dir_exists("#{Catapult::Config.base_catapult_component_config_dir}/#{self.type}")
      end
      
      def base_catapult_component_config_dir
        Catapult.base_catapult_component_config_dir
      end
      
      def absolute_file_paths_in_directory(dir)
          Dir.entries(dir).map { |path| File.expand_path(path, dir) }.select { |path| File.file?(path) }
      end
      
        # file_type can be :script, :config_file
      def relative_path(file_type, filename)
        relative_path?(file_type, filename) || fail("Unexpected that relative_path?(type, filename) is nil")
      end
      
      def check_dir_exists(dir)
        fail "Config dir '#{dir}' for type '#{self.type}' does not exist" unless Dir.exists?(dir)
        dir
      end
      
      # This is both files to copy and template files
      def all_files_in_config_info_dir
        absolute_file_paths_in_directory(self.config_info_dir)
      end
      
      # This method could be overwritten
      def catapult_peers_relative_paths
        []
      end
      
      private
      
      # file_type can be :script, :config_file
      def self.relative_path?(_file_type, _filename)      
        DTK.fail_if_not_concrete(self)
      end
    end        
    
    module Mixin
      # This is both files to copy and template files
      def all_files_in_config_info_dir
        @all_files_in_config_info_dir ||= self.class.all_files_in_config_info_dir
      end
      
      def all_files_in_scripts_dir
        @all_files_in_scripts_dir ||= self.class.all_files_in_scripts_dir
      end
      
      def data_dir?
        DTK.fail_if_not_concrete(self)
      end
      
      private
      
      def check_dir_exists(dir)
        self.class.check_dir_exists(dir)
      end
      
      def absolute_file_paths_in_directory(dir)
        self.class.absolute_file_paths_in_directory(dir)
      end
      
      def relative_path(file_type, filename)
        self.class.relative_path(file_type, filename)
      end
        
    end
  end
end
