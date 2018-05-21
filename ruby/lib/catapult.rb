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

require 'fileutils'
require 'mustache'
require 'yaml'
module Catapult
  require_relative('catapult/global')
  # global must go first
  require_relative('catapult/addresses')
  require_relative('catapult/config')

  BASE_CONFIG_SOURCE_DIR  = File.expand_path('../catapult-templates', File.dirname(__FILE__))
  
  def self.base_config_source_dir
    BASE_CONFIG_SOURCE_DIR
  end

  def self.bind_mustache_variables(template, template_attributes_hash)
    ret = ::Mustache.render(template, template_attributes_hash)
    ret.gsub('&#39;',"'") # protection around ::Mustache.render "'" to '&#39;'
  end
end
