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
input_file_path = ARGV[0]
output_file_path = ARGV[1]     
fail "No file exists at path '#{input_file_path}'" unless File.file?(input_file_path)
unless File.file?(output_file_path)
  ruby_object = Catapult::Addresses.parse(input_file_path)
  File.open(output_file_path, 'w') { |f| f << YAML.dump(ruby_object) }
end
