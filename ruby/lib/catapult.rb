require 'fileutils'
require 'mustache'
require 'yaml'
module Catapult
  #    require_relative('catapult/aux')
  #    require_relative('catapult/component')
  require_relative('catapult/config')
  #    require_relative('catapult/directory')
  require_relative('catapult/global')
  #    require_relative('catapult/nemesis')
  BASE_CONFIG_SOURCE_DIR    = File.expand_path('../../catapult-config/templates', File.dirname(__FILE__))
  
  def self.base_catapult_component_config_dir
    BASE_CONFIG_SOURCE_DIR
  end

  def self.bind_mustache_variables(template, template_attributes_hash)
    ::Mustache.render(template, template_attributes_hash)
  end
end
