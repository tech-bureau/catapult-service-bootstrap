require 'yaml'
module SymbolUtilities
  class ConfigInput < ::Hash
    def initialize(config_input_dir)
      replace(render_as_hash(config_input_dir))
    end

    KEYS = [
      :boot_private_key,
      :public_key,
      :harvester_private_key,
      :friendly_name,
      :type,
      :name_without_region,
      :aws_region,
      :influxdb_host
    ]
    
    def method_missing(method, *args)
      if KEYS.include?(method)
        self[method]
      else
        super
      end
    end

    def respond_to?(method)
      KEYS.include?(method) or super
    end

    private

    CONFIG_INPUT_FILENAME = 'config-input.yaml'
    
    def render_as_hash(config_input_dir)
      path = "#{config_input_dir}/#{CONFIG_INPUT_FILENAME}"
      fail "File does not exist: #{path}" unless ::File.file?(path)
      keys_as_symbols(::YAML.load(::File.open(path).read))[:attributes]
    end

    def keys_as_symbols(obj)
      case obj
      when ::Hash
        obj.inject({}) { |h, (k, v)| h.merge(k.to_sym => keys_as_symbols(v)) }
      when ::Array
        obj.map { |el| keys_as_symbols(el) }
      else
        obj
      end
    end
    
  end
end
