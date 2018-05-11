module Catapult
  class Config::CatapultNode
    class TemplateAttributes
      require_relative('template_attributes/per_index')
      def initialize(type, component_keys, input_attributes)
        @type             = type
        @component_keys   = component_keys
        @input_attributes = input_attributes
      end
        
      attr_reader :type, :component_keys
      
      def hash(index)
        PerIndex.new(self, index).hash
      end
      
      def harvest_keys
        @harvest_keys ||= Config::Keys::Nemesis.get_keys_info_array_for_harvesting(self.input_attributes).map(&:private)
      end

      def network_public_key
        @network_public_key ||= Config::Keys::Nemesis.key_info_signer_private_key(self.input_attributes).public
      end

      def network_generation_hash
        @network_generation_hash ||= Config::Keys::Nemesis.key_info_generation_hash(self.input_attributes).public
      end

      protected

      attr_reader :input_attributes

    end        
  end
end



 

