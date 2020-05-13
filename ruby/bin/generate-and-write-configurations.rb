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
unless ARGV.size == 3
  STDERR << "Usage #{$0} KEYS_FILE_PATH BASE_CONFIG_DIR NEMESIS_DIR\n"
  exit 1
end

keys_file_path         = ARGV[0]
base_config_target_dir = ARGV[1]
nemesis_dir            = ARGV[2]
keys = ::YAML.load(::File.open(keys_file_path).read)

include Catapult::Bootstrap
Directory::Nemesis.set!(nemesis_dir)
Directory::BaseConfig.set!(base_config_target_dir)

# TODO: remove base_config_target_dir
Catapult::Bootstrap::Config.generate_and_write(keys, base_config_target_dir, overwrite: false)
Tools::Nemesis::Nemgen.generate_and_write

