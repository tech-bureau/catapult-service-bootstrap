module SymbolUtilities
  module Parse
    class Health
      require_relative('health/metrics')
      def initialize(raw_health_info)
        @input = raw_health_info
        @grok = ret_grok_with_symbol_metric_patterns
      end

      def self.parse(raw_health_info)
        new(raw_health_info).parse
      end

      def parse
        self.metrics.inject({}) do |h, metric|
          if match = self.grok.match?(self.input, metric)
            h.merge(metric.downcase => convert_data_to_int(match['data']))
          else
            fail "No match for metric '#{metric}'"
          end
        end
      end

      protected
      
      attr_reader :input, :grok

      def metrics
        METRICS
      end

      private

      def ret_grok_with_symbol_metric_patterns
        grok = Parse::Grok.new.add_pattern!('SYMBOL_VALUE', "[0-9']+")
        self.metrics.each { |metric| grok.add_pattern!(metric, pattern_for_metric(metric)) }
        grok
      end

      def pattern_for_metric(metric)
        "#{metric.gsub('_', ' ')} : %{SYMBOL_VALUE:data}"
      end

      def convert_data_to_int(data)
        unless data.kind_of?(::Array) and data.size == 1
          fail "data should be a singleton array; it instead is: #{data.inspect}"
        end
        data.first.gsub("'", '').to_i
      end

    end
  end
end
