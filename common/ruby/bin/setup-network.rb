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
base_data_dir          = ENV['BASE_DATA_DIR'] || fail("Missing env var BASE_DATA_DIR")
nemesis_dir            = ENV['NEMESIS_DIR'] || fail("Missing env var NEMESIS_DIR")

include Catapult::Bootstrap

######### generate addresses
parsed_addresses_path = "#{addresses_dir}/addresses.yaml"
keys = 
  unless ::File.file?(parsed_addresses_path)
    ruby_obj = Addresses.generate_and_parse(Global.num_generated_addresses, output_form: :hash_for_yaml)
    ::File.open(parsed_addresses_path, 'w') { |f| f << ::YAML.dump(ruby_obj) }
    ruby_obj
  else
    ::YAML.load(::File.open(parsed_addresses_path).read)
  end

######### end: generate addresses

Directory::Nemesis.set!(nemesis_dir)
Directory::BaseConfig.set!(base_config_target_dir)
Directory::BaseData.set!(base_data_dir)

Config.generate_and_write(keys, overwrite: false)
Tools::Nemesis::Nemgen.generate_and_write

