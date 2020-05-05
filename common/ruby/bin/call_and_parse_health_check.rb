#!/usr/bin/env ruby
require 'open3'
require 'yaml'
require_relative('../lib/catapult')

output_stats_file = ARGV[0] || fail("Missing HEALTH_CHECK_STATS_FILE") 

stdout, stderr, status = ::Open3.capture3("/usr/catapult/bin/catapult.tools.health -r /userconfig")
fail "The call to catapult.tools.health failed" unless status.success?
raw_logs = stderr

parsed_hash = SymbolUtilities::HealthCheck::LogParser.new(raw_logs).parsed_hash
::File.open(output_stats_file, 'w') { |f| f << ::YAML.dump(parsed_hash) }
