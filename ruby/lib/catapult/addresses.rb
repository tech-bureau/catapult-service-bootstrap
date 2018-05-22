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
module Catapult
  module Addresses
    SECTION_SIZES = {
      Global::ParseKey.peer_nodes                   => 5,
      Global::ParseKey.api_nodes                    => 2,
      Global::ParseKey.rest_gateways                => 2,
      Global::ParseKey.nemesis_addresses_harvesting => 3,
      Global::ParseKey.nemesis_generation_hash      => 1,
      Global::ParseKey.nemesis_signer_private_key   => 1
      # Global::ParseKey.nemesis_addresses => * # dyanmically calculated using left over address
    }

    # returns ruby object
    def self.parse(input_file_path)
      parsed_flat_form = parse_into_flat_form(input_file_path)
      break_into_sections(parsed_flat_form)
    end

    private

    def self.parse_into_flat_form(input_file_path)
      parsed_form = []
      next_state   = :private # states can be :private, :public, :address
      next_element = {}
      File.open(input_file_path).read.each_line do |line|
        next unless line =~ Regexp.new("#{next_state}")
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
      parsed_form
    end


    def self.break_into_sections(parsed_flat_form)
      num_nemesis_addresses = parsed_flat_form.size - SECTION_SIZES.values.inject(0, :+) - 2
      unless num_nemesis_addresses > 0
        fail "Not enough addresses"
      end
      parsed_form = {}
      index       = 0
      SECTION_SIZES.each_pair do |component_type, size|
        parsed_form[component_type.to_s] = parsed_flat_form[index..index+size-1]
        index = index+size
      end
      parsed_form['nemesis_addresses'] = parsed_flat_form[index..index+num_nemesis_addresses-1]
      parsed_form
    end
    
    def self.add_to_element!(element, state, line)
      value = 
        case state
        when :private 
        value(state, line, /private key: ([0-9A-Z]+)/)
        when :public
          value(state, line, /public key: ([0-9A-Z]+)/)
        when :address
          value(state, line, Regexp.new("address \\(#{Global.catapult_nework_identifier}\\): ([0-9A-Z]+)"))
        end
      element.merge!(state.to_s => value)
    end

    def self.value(state, line, regexp)
      unless line =~ regexp
        fail "Cannot find #{state} data"
      end
      $1
    end
  end
end
  

