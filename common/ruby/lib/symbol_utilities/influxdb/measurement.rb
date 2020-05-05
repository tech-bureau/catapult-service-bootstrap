module SymbolUtilities
  module Influxdb
    class Measurement
      def initialize(measurement_name, client)
        @measurement_name = measurement_name
        @client           = client
      end
      
      def write_point(value_hash, tags_hash = {})
        data = {
          values: value_hash,
          tags:   tags_hash
        }
        self.client.write_point(self.measurement_name, data)
      end
      
      # For testing
      def get_last_point(tags_hash = {})
        get_last_point_helper_aux(tags_hash)
      end
      
      protected
      
      attr_reader :measurement_name, :client
      
      private
      
      def get_last_point_helper_aux(tags_hash = {})
        self.client.query("select last(*) from #{self.measurement_name} #{where_clause(tags_hash)}")
      end
      
      def where_clause(tags_hash)
        clause = ''
        tags_hash.each_pair do |name, value|
          unless value.nil?
            if clause.empty?
              clause += where_clause_term(name, value)
            else
              clause += " AND #{where_clause_term(name, value)}"
            end
          end   
        end
        clause.empty? ? '' : "WHERE #{clause}"
      end
      
      def where_clause_term(name, value)
        fail_if_illegal_tag_value(name, value)
        "#{name} ='#{value}'" 
      end
      
      LEGAL_TAG_CLASSES = [::String, ::Symbol, ::Integer]
      
      def fail_if_illegal_tag_value(name, value)
        unless LEGAL_TAG_CLASSES.include?(value.class)
          fail "Param '#{name} has an illegal type' legal types of #{LEGAL_TAG_CLASSES.join(', ')}"
        end
      end
      
    end
  end
end
