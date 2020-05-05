module SymbolUtilities
  class Tools::Health
    class InfluxdbHandle
      DEFAULT_MEASURE_NAME = 'symbol_health_checks'
      def initialize(database, config_input, measurement_name: DEFAULT_MEASURE_NAME)
        @database     = database
        @config_input = config_input
        @client       = Influxdb::Client.new(database, host: config_input.influxdb_host)
        @measurement  = @client.measurement(measurement_name)
      end
      
      def write_point(value_hash)
        self.measurement.write_point(value_hash, self.tag_hash)
      end

      # For testing
      def get_last_point
        self.measurement.get_last_point(self.tag_hash)
      end
      
      protected
      
      attr_reader :database, :config_input, :client, :measurement
      
      def tag_hash
        # TODO: check if error is thrown by self.config_input.foo if foo is nil
        # can use :name 
        @tag_hash ||= {
          peer_type: self.config_input.type,
          peer_name: self.config_input.name_without_region,
          peer_region: self.config_input.aws_region
        }
      end

    end
  end
end
