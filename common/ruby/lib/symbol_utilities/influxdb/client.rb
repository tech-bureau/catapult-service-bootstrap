require 'influxdb'
module SymbolUtilities
  module Influxdb
    class Client
      DEFAULT_HOST = 'localhost'
      def initialize(database, host: DEFAULT_HOST, retry_in_seconds: nil)
        @database = database
        @conn     = ret_conn(InputParams.new(database, host, retry_in_seconds))
        create_database?
      end

      InputParams = Struct.new(:database, :host, :retry)

      # query_expression is a string
      def query(query_expression)
        self.conn.query(query_expression)
      end

      def write_point(name, data)
        self.conn.write_point(name.to_s, data)
      end

      def measurement(measurement_name)
        Measurement.new(measurement_name, self)
      end

      def create_database?
        # This will still work if database is created already, in which case its a no op
        self.conn.query("CREATE DATABASE #{self.database}")
      end

      protected

      attr_reader :conn, :database

      private

      def ret_conn(input_params)
        ::InfluxDB::Client.new(input_params.database, influxdb_params(input_params))
      end

      def influxdb_params(input_params)
        # TODO: stubbing connection params
        {
          url: database_url(input_params),
          username: 'root',
          password: 'root',
          time_precision: 's'
        }
      end

      DEFAULT_DB_PORT = 8086
      def database_url(input_params)
        "http://#{input_params.host}:#{DEFAULT_DB_PORT}/#{input_params.database}#{retry_query_string(input_params)}"
      end

      def retry_query_string(input_params)     
        input_params.retry ? "?retry=#{input_params.retry}" : ''
      end

      def camelcase(snake_case)
        snake_case.split('_').collect(&:capitalize).join
      end
    end
  end
end
