#!/usr/bin/env ruby
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
require_relative('../lib/catapult.rb')
unless ARGV.size == 0
  STDERR << "Usage #{$0}\n"
  exit 1
end
addresses_dir          = ENV['ADDRESSES_DIR'] || fail("Missing env var ADDRESSES_DIR")
base_config_target_dir = ENV['BASE_CONFIG_DIR'] || fail("Missing env var BASE_CONFIG_DIR")
nemesis_dir            = ENV['NEMESIS_DIR'] || fail("Missing env var NEMESIS_DIR")
number_of_addressses   = (ENV['NUMBER_OF_ADDRESSES'] || fail("Missing env var NUMBER_OF_ADDRESSES")).to_i

include Catapult::Bootstrap

######### generate addresses
## TODO: this wil be cleaned up
raw_addresses    = "#{addresses_dir}/raw-addresses.txt"
parsed_addresses = "#{addresses_dir}/addresses.yaml"
fail "No file exists at path '#{raw_addresses}'" unless File.file?(raw_addresses)

keys = 
  unless File.file?(parsed_addresses)
    ruby_obj = Addresses.parse(raw_addresses, number_of_addressses, output_form: :hash_for_yaml)
    ::File.open(parsed_addresses, 'w') { |f| f << ::YAML.dump(ruby_obj) }
    ruby_obj
  else
    ::YAML.load(::File.open(parsed_addresses).read)
  end

######### end: generate addresses
Directory::Nemesis.set!(nemesis_dir)
Directory::BaseConfig.set!(base_config_target_dir)

# TODO: remove base_config_target_dir
Catapult::Bootstrap::Config.generate_and_write(keys, base_config_target_dir, overwrite: false)
Tools::Nemesis::Nemgen.generate_and_write

