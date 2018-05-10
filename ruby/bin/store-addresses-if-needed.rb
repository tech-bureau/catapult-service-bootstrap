#!/usr/bin/env ruby
require_relative('../lib/catapult.rb')
input_file_path = ARGV[0]
output_file_path = ARGV[1]     
fail "No file exists at path '#{input_file_path}'" unless File.file?(input_file_path)
unless File.file?(output_file_path)
  ruby_object = Catapult::Addresses.parse(input_file_path)
  File.open(output_file_path, 'w') { |f| f << YAML.dump(ruby_object) }
end
