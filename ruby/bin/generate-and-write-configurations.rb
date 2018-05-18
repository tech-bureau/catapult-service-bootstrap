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
keys_file_path         = ARGV[0]
base_config_target_dir = ARGV[1]
nemesis_dir            = ARGV[2]

keys = YAML.load(File.open(keys_file_path).read)
Catapult::Config.generate_and_write_configurations(keys, base_config_target_dir, nemesis_dir)

