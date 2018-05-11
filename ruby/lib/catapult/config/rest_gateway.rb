module Catapult
  class Config
    class RestGateway < self
      require_relative('rest_gateway/template_attributes')

      CONFIG_SUBDIR = 'userconfig'
      TYPE          = :rest_gateway
      def initialize(input_attributes)
        @component_keys = Keys::Component.new(input_attributes)
        super(TYPE, input_attributes, TemplateAttributes.new(@component_keys, input_attributes))
      end
      private :initialize

      protected

      attr_reader :component_keys
      
      private
      
      def self.config_info_dir
        check_dir_exists("#{Config.base_config_source_dir}/#{self.type}")
      end
      
      # file_type can be :script, :config_file
      def self.relative_path?(file_type, filename)      
        case file_type
        when :config_file
          "#{CONFIG_SUBDIR}/#{filename}"
        end
      end

    end
  end
end
