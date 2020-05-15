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
    require_relative('config/nemesis')
    require_relative('config/keys')
    require_relative('config/paths')
    require_relative('config/source_target_pair')
    
    # child classes
    require_relative('config/catapult_node')
    require_relative('config/rest_gateway')
    
    include Paths::Mixin
    extend Paths::ClassMixin

    include Mixin::Mustache
    
    def initialize(type, template_attributes)
      @type                  = type
      @config_info_dir       = self.class.config_info_dir
      @template_attributes   = template_attributes
      # gets dynamically updated
      @ndx_config_files = {} #@ndx_config_files is indexed by Global.component_address(node_type, index)
    end
    
    private :initialize

    def self.generate_and_write(raw_keys_input, overwrite: false)
      unless overwrite 
        return if configs_generated_already?
      end
      keys_handle  = Keys::Handle.new(raw_keys_input)
      indexed_node_objects = {
        peer_node: CatapultNode::PeerNode.new(keys_handle),
        api_node: CatapultNode::ApiNode.new(keys_handle)
      }
      keys_handle.update_with_cert_info!(indexed_node_objects)

      generate_and_write_component_configurations!(keys_handle, indexed_node_objects)
      # above goes first because it updates key handle and generates the node config, which is neeed by nemesis linker
      Nemesis.generate_and_write_files(keys_handle)
    end

    def self.cardinality(type)
      Global::ComponentCardinaity::HASH[type] || fail("Unexpected type '#{type}'")
    end
    
    def self.type
      self::TYPE
    end

    def self.component_indexes(cardinality)
      (0..cardinality-1).to_a
    end

    def component_dir_full_path(component_index)
      "#{self.class.base_config_target_dir}/#{component_ref(component_index)}"
    end

    def component_indexes
      @component_indexes ||= self.class.component_indexes(self.cardinality)
    end

    def self.sample_component_userconfig_dir
      @sample_component_userconfig_dir ||= self.component_userconfig_dir
    end

    protected
    
    attr_reader :type, :config_info_dir, :template_attributes, :ndx_config_files

    def self.component_dir(component_ref) 
      "#{self.base_config_target_dir}/#{component_ref}"
    end

    def self.base_config_target_dir
      Directory::BaseConfig.full_path
    end

    def cardinality
      # This might be called before self.type is set
      @cardinality ||= self.class.cardinality(self.type || self.class.type)
    end

    private

    def self.configs_generated_already?
      # Testing just one sample file in one sample node dir
      sample_config_file = "#{self.sample_component_userconfig_dir}/resources/config-network.properties"
      File.exists?(sample_config_file)
    end

    def self.generate_and_write_component_configurations!(keys_handle, indexed_node_objects)
      ndx_config_files = {}
      ndx_config_files.merge!(indexed_node_objects[:peer_node].generate)
      ndx_config_files.merge!(indexed_node_objects[:api_node].generate)
      ndx_config_files.merge!(RestGateway.new(keys_handle).generate)
      write_out_config_files(ndx_config_files)
    end

    def generate
      add_static_config_files!
      add_instantiate_config_templates!
      self.ndx_config_files
    end
    public :generate

    def add_static_config_files!
      add_static_files!(:config_file, self.all_files_in_config_info_dir)
    end

    # type can be :script, :config_file
    def add_static_files!(file_type, static_files)
      SourceTargetPair.config_files(static_files).each do |pair|
        path    = relative_path(file_type, pair.filename)
        content = File.open(pair.source_path).read
        self.component_indexes.each { |index| add_config_file!(index, path, content) }
      end
    end
    
    # Can be overwritten
    def add_instantiate_config_templates!
      SourceTargetPair.config_templates(self.all_files_in_config_info_dir).each do |pair|
        template_path = pair.source_path
        template      = File.open(template_path).read
        self.component_indexes.each do |index| 
          instantiated_template = bind_mustache_variables(template, self.template_attributes.hash(index))
          path = relative_path(:config_file, pair.filename)
          add_config_file!(index, path, instantiated_template)
        end 
      end
    end
    
    def add_config_file!(component_index, path, content)
      component_ref = Global.component_address(self.type, component_index)
      (self.ndx_config_files[component_ref] ||= {}).merge!(path => content)
    end

    def component_ref(component_index)
      Global.component_address(self.type, component_index)
    end

    def self.write_out_config_files(ndx_config_files)
      ndx_config_files.each_pair do |component_ref, info|
        component_dir = component_dir(component_ref)
        info.each_pair do |path, content|
          full_path = "#{component_dir}/#{path}"
          FileUtils.mkdir_p(directory_part(full_path))
          File.open(full_path, 'w') { |f| f << content }
        end
      end
    end

    def self.directory_part(full_path)
      split = full_path.split('/')
      split.pop
      split.join('/')
    end

  end
end
