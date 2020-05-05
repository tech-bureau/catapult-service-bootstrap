module SymbolUtilities
  class Tools
    class Health < self
      require_relative('health/private_key')
      require_relative('health/influxdb_handle')

      # This is dependent on what peers-p2p.json in config dir is pointing to
      # Current assumption is that it just points to a single peer

      def self.get_and_write_health_info(influxdb_handle)
        new.get_and_write_health_info(influxdb_handle)
      end
      def get_and_write_health_info(influxdb_handle)
        health_info = get_health_info
        influxdb_handle.write_point(health_info)
      end

      def self.get_health_info
        new.get_health_info
      end
      def get_health_info
        raw_health_info = get_health_info_raw_data
        Parse::Health.parse(raw_health_info)
      end
      
      def self.get_health_info_raw_data 
        new.get_health_info_raw_data
      end
      def get_health_info_raw_data
        execute_info = execute_command_all_info("#{self.executable} -r #{self.resource_dir} --clientPrivateKey #{self.client_private_key}", timeout: 5)
        # raw_health info is under stderr
         execute_info.stderr
      end

      protected
      
      def client_private_key
        @client_private_key ||= PrivateKey.client_private_key
      end

    end
  end
end
