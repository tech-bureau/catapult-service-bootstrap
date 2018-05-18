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
class Catapult::Config
  class SourceTargetPair
    def initialize(filename, source_path)
      @filename    = filename
      @source_path = source_path
    end
    
    attr_reader :filename, :source_path
    
    def self.config_files(config_info_dir_files)
      source_paths = config_info_dir_files.reject { |path| path =~ TEMPLATE_FILE_REGEXP }
      source_paths.map do |source_path|
        filename    = source_path.split('/').last
        new(filename, source_path)
      end
    end
    
    def self.config_templates(config_info_dir_files)
      template_paths = config_info_dir_files.select { |path| path =~ TEMPLATE_FILE_REGEXP }
      template_paths.map do |template_path|
        filename    = template_path.split('/').last.sub(TEMPLATE_FILE_REGEXP, '')
        new(filename, template_path)
      end
    end
    
    TEMPLATE_FILE_REGEXP = /\.mt$/
  end
end


 

