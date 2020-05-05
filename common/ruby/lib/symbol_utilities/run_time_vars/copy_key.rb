module SymbolUtilities
  class RunTimeVars
    class CopyKey < self
      def self.run(node_type, component_keys, overwrite: false, identity_dir: nil)
        self.elements(component_keys: component_keys, node_type: node_type, identity_dir: identity_dir).each { |el| el.run(overwrite: overwrite) }
      end

      def run(overwrite: false)
        # dont replace existing values unless overwrite is true and donot_overwrite is false
        if self.component_config.value?.nil? or 
          (overwrite and ! self.component_config.donot_overwrite)
          case self.component_config.type
          when :copy_key
            copy_key
          when :friendly_name
            set_friendly_name
          else
            fail "Illegal type '#{self.type}'"
          end  
        end
      end

      def key_needs_to_be_copied?
        self.component_config.type == :copy_key and self.component_config.value?.nil?
      end
      
      protected

      def address_position?
        self.component_config.address_position?
      end
      
      def address_position
        @address_position ||= self.address_position? || fail("Unexpected that address_position? is nil")
      end

      def key_type
        @key_type ||= self.component_config.key_type
      end

      def attribute_name
        @attribute_name ||= self.component_config.attribute_name
      end

      private

      def copy_key
        key = get_key
        update_attribute!(self.attribute_name, key)
        write_component_config
      end

      def get_key(key_type = nil)
        key_type ||= self.key_type
        self.component_keys.get_key(key_type, self.node_type, self.address_position)
      end

      # TODO: change to use the config input user friendly name info
      FRIENDLY_NAME_ID_LEN = 7
      def set_friendly_name
        public_key = get_key(:public)
        friendly_name = "#{public_key[0..FRIENDLY_NAME_ID_LEN]}"
        update_attribute!(self.attribute_name, friendly_name)
        write_component_config
      end

      def write_component_config
        ::File.open(self.component_config.path, 'w') { |f| f << ::YAML.dump(self.component_config.hash) }
      end

    end
  end
end
