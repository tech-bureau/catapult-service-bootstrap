module SymbolUtilities
  class RunTimeVars
    META_FILENAME = 'meta.yaml'
    META_PATH     = ::File.expand_path("config/#{META_FILENAME}", RUBY_BASE_DIR)
    require_relative('run_time_vars/component_config')
    require_relative('run_time_vars/copy_key')
    require_relative('run_time_vars/set_var')

    def initialize(name, source, targets, component_keys: nil, node_type: nil, identity_dir: nil)
      @name             = name
      @component_config = ComponentConfig.new(source, identity_dir: identity_dir)
      @targets          = targets
      @component_keys   = component_keys
      @node_type        = node_type
    end

    # Could be overwritten
    def self.run(component_keys: nil, node_type: nil)
      self.elements(component_keys: component_keys, node_type: node_type).each { |el| el.run }
    end

    def self.is_processing_needed?
      ! CopyKey.elements.find { |el| el.key_needs_to_be_copied? }.nil?
    end
    
    def self.fqdn(rel_path)
      ::File.expand_path(rel_path, Directory.base)
    end

    def self.yaml_file_to_hash(path)
      if ::File.exists?(path)
        yaml_text = ::File.open(path).read
        unless yaml_text.empty?
          ::YAML.load(yaml_text)
        end
      end || {}
    end

    protected

    attr_reader :name, :component_config, :targets

    def component_keys
      @component_keys || fail("Unexpected that @component_keys is nil")
    end

    def node_type
      @node_type || fail("Unexpected that @node_type is nil")
    end


    def self.meta_hash
      @meta_hash ||= yaml_file_to_hash(META_PATH)
    end

    private
    
    def self.elements(component_keys: nil, node_type: nil, identity_dir: nil)
      self.meta_hash['run_time_vars'].map do |var_info|
        new(var_info['name'], var_info['source'], var_info['targets'], component_keys: component_keys, node_type: node_type, identity_dir: identity_dir)
      end
    end

    def update_attribute!(attribute_name, value)
      self.component_config.update_attribute!(attribute_name, value)
    end

  end
end
                            
