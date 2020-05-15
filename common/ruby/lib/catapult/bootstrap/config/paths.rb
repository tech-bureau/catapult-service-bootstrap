#    Copyright 2018 Tech Bureau, Corp
# 
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
# 
#        http://www.apache.org/licenses/LICENSE-2.0
# 
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.
module Catapult::Bootstrap
  class Config
    module Paths
      module ClassMixin
        
        SAMPLE_COMPONENT_TYPE = :peer_node
        def component_userconfig_dir(type: SAMPLE_COMPONENT_TYPE, index: 0)
          "#{self.base_config_target_dir}/#{component_sub_dir(type, index)}/userconfig"
        end
        
        def component_data_dir(type:, index:)
          "#{Directory::BaseData.full_path}/#{component_sub_dir(type, index)}"
        end
        
        # This method could be overwritten
        def config_info_dir
          check_dir_exists("#{Catapult::Config.base_config_source_dir}/#{self.type}")
        end
        
        def base_config_source_dir
          Catapult::Bootstrap.base_config_source_dir
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
        
        def component_sub_dir(type, index) 
          "#{type.to_s.gsub('_', '-')}-#{index}"
        end
        
        # TODO: is below used and if so why is it self.relative_path? rather than relative_path?
        # file_type can be :script, :config_file
        def self.relative_path?(_file_type, _filename)      
          fail "Method must be written for class '#{self}'"
        end
      end        
      
      module Mixin
        
        # This is both files to copy and template files
        def all_files_in_config_info_dir
          @all_files_in_config_info_dir ||= self.class.all_files_in_config_info_dir
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
end
