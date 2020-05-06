#    Copyright 2018 Tech Bureau, Corp
# 
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
# 
#        http://www.apache.org/licenses/LICENSE-2.0
# 
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.
module Catapult::Bootstrap
  class Addresses
    class Parse
      DEFAULT_OUTPUT_FORM = :element
      def initialize(raw_address_info, section_sizes, break_into_sections: false, output_form: nil)
        @raw_address_info    = raw_address_info
        @section_sizes       = section_sizes
        @break_into_sections = break_into_sections
        @output_form         = output_form || DEFAULT_OUTPUT_FORM
      end

      ADDRESS_TYPES = [:private, :public, :address]
      Element = Struct.new(*ADDRESS_TYPES)

      def self.parse(raw_address_info, section_sizes, break_into_sections: false, output_form: nil)
        new(raw_address_info, section_sizes, break_into_sections: break_into_sections, output_form: output_form).parse
      end
      def parse
        self.should_break_into_sections? ? break_into_sections(self.parsed_flat_form) : self.parsed_flat_form
      end

      protected

      attr_reader :raw_address_info, :section_sizes, :output_form

      def should_break_into_sections?
        @break_into_sections
      end

      def parsed_flat_form
        @parsed_flat_form ||= parse_into_flat_form
      end

      private

      def parse_into_flat_form
        parsed_form = []
        next_state   = :private # states can be :private, :public, :address
        next_element = {}
        self.raw_address_info.each_line do |line|
          next unless line =~ ::Regexp.new("#{next_state}")
          add_to_element!(next_element, next_state, line)
          case next_state
          when :private 
            next_state = :public
          when :public
            next_state = :address
          when :address
            parsed_form << next_element
            next_element = {}
            next_state = :private
          end
        end
        render_in_output_form(parsed_form)
      end

      def break_into_sections(parsed_flat_form)
        parsed_form = {}
        index       = 0
        self.section_sizes.each_pair do |component_type, size|
          parsed_form[component_type.to_s] = parsed_flat_form[index..index+size-1]
          index += size
        end
        parsed_form
      end
      
      def add_to_element!(element, state, line)
        value = 
          case state
          when :private 
            value(state, line, /private key: ([0-9A-Z]+)/)
          when :public
            value(state, line, /public key: ([0-9A-Z]+)/)
          when :address
            value(state, line, Regexp.new("address \\(#{Global.catapult_nework_identifier}\\): ([0-9A-Z]+)"))
          end
        element.merge!(state => value)
      end
      
      def value(state, line, regexp)
        unless line =~ regexp
          fail "Cannot find #{state} data"
        end
        $1
      end

      def render_in_output_form(parsed_form)
        case self.output_form
        when :element
          parsed_form.map { |hash| Element.new(hash[:private], hash[:public], hash[:address]) }
        when :hash_for_yaml
          parsed_form.map { |hash| hash.inject({}) { |h, (k, v)| h.merge(k.to_s => v) } }
        else
          fail "Illegal output_form '#{self.output_form}'"
        end
      end

    end
  end
end

