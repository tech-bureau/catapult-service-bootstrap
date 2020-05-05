$:.push File.expand_path("../lib", __FILE__)
require "symbol_utilities/version"

Gem::Specification.new do |s|
  s.name        = "symbol-utilities"
  s.version     = SymbolUtilities::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Rich Pelavin"]
  s.email       = [""]
  s.summary     = "Code to interact with Atlassian status page"
  s.license     = "Unlicense"
  s.required_ruby_version = ">= 2.5"
  s.add_dependency 'mustache', '~> 1.1', '>= 1.1.1'
  s.add_dependency 'frontkick', '~> 0.5', '>= 0.5.7'
  s.add_dependency 'jls-grok', '~> 0.11', '>= 0.11.5'
  s.add_dependency 'influxdb', '~> 0.8', '>= 0.8.0'
  s.add_development_dependency 'rspec', '~> 3.6', '>= 3.6.0'

  s.files         = `find *`.split("\n").uniq.sort.select { |f| !f.empty? }.reject { |f| f =~ /gem$/ or f =~ /gemspec$/ }
  s.test_files    = `find spec/*`.split("\n")
  s.executables   = ::Dir['bin/*'].map { |path| path.sub(/^bin\//, '') }
  s.require_paths = ["lib"]
end
