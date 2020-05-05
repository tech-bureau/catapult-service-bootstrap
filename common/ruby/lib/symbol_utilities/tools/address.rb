module SymbolUtilities
  class Tools
    class Address < self
      def self.generate_addresses(num_addresses)
        new.generate_addresses(num_addresses)
      end
      def generate_addresses(num_addresses)
        raw_addresses = execute_command("#{self.executable} -g #{num_addresses} -n #{self.network}")
        Parse::Addresses.parse(raw_addresses)
      end

      def self.generate_address(type = nil)
        new.generate_address(type)
      end
      def generate_address(type = nil)
        address_element = generate_addresses(1).first
        if type
          "Fail illegal address type '#{type}'" unless Parse::Addresses::ADDRESS_TYPES.include?(type)
          address_element.send(type)
        else
          address_element
        end
      end

    end
  end
end
