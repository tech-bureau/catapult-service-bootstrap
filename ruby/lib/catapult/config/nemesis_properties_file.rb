module Catapult
  class Config
    class NemesisPropertiesFile
      require_relative('nemesis_properties_file/template_bindings')

      CONFIG_FILENAME = 'block-properties-file.properties'

      def initialize(input_attributes)
        @input_attributes = input_attributes
      end

      private :initialize

      def self.generate_file(input_attributes)
        new(input_attributes).generate_file
      end
      def generate_file
        config_file = ret_nemesis_config
        write_config_file(config_file)
      end      

      def self.config_filename
        CONFIG_FILENAME
      end
      protected

      attr_reader :input_attributes

      def template
        @template ||= File.open(self.template_file).read
      end
      
      def template_file
        "#{Config.base_config_dir}/nemesis/#{self.config_filename}.mt"
      end
      
      def config_filename
        self.class.config_filename
      end

      private

      def ret_nemesis_config
        nemesis_keys_info = Config::Keys::Nemesis.get_nemesis_keys_info(self.input_attributes)
        template_bindings = TemplateBindings.template_bindings(nemesis_keys_info)
        Catapult.bind_mustache_variables(self.template, template_bindings)
      end

      # TODO: stub
      BASE_DIR = '/tmp/community/'
      def write_config_file(config_file)
        File.open("#{BASE_DIR}/#{self.config_filename}", 'w') { |f| f << config_file }
      end
      
    end
  end
end



