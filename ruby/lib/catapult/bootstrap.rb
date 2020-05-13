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

module Catapult
  module Bootstrap
    require_relative('bootstrap/mixin')
    require_relative('bootstrap/global')
    # mixin and global must go first
    require_relative('bootstrap/addresses')
    require_relative('bootstrap/config')
    require_relative('bootstrap/directory')
    require_relative('bootstrap/tools')
    
    BASE_CONFIG_SOURCE_DIR  = File.expand_path('../../catapult-templates', File.dirname(__FILE__))
    
    def self.base_config_source_dir
      BASE_CONFIG_SOURCE_DIR
    end
    

  end
end

