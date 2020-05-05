module SymbolUtilities
  class Tools::Health
    class PrivateKey < self
      
      def self.client_private_key
        new.client_private_key
      end
      @@client_private_key = nil
      def client_private_key
        @@client_private_key ||= get_private_key? || generate_and_write_private_key
      end

      protected

      HEALTH_CHECK_PRIVATE_KEY_FILENAME = 'health_check_client_private_key'
      def private_key_path
        "#{self.addresses_dir}/#{HEALTH_CHECK_PRIVATE_KEY_FILENAME}"
      end

      private

      def get_private_key?
        if ::File.file?(self.private_key_path)
          ::File.read(self.private_key_path)
        end
      end

      def generate_and_write_private_key
        private_key = Tools::Address.generate_address(:private)
        ::File.open(self.private_key_path, 'w') { |f| f << private_key }
        private_key
      end

    end
  end
end
