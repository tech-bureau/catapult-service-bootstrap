module Catapult::Bootstrap
  class Tools
    class Address < self
      def self.generate_raw_addresses(num_addresses)
        new.generate_raw_addresses(num_addresses)
      end
      def generate_raw_addresses(num_addresses)
        execute_command("#{self.executable} -g #{num_addresses} -n #{self.network}")
      end

      protected

      def network
        @network ||= Global.catapult_nework_identifier
      end

    end
  end
end
