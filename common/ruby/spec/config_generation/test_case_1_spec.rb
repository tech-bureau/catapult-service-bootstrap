require 'fileutils'
require 'yaml'
require_relative('../../lib/catapult')
require 'byebug' 

KEYS_FILE_PATH         = ::File.expand_path('../resources/build/generated-addresses/addresses.yaml', ::File.dirname(__FILE__))
BASE_CONFIG_TARGET_DIR = ::File.expand_path('./output/build/catapult-config', ::File.dirname(__FILE__))
NEMESIS_DIR            = ::File.expand_path('./output/build/nemesis', ::File.dirname(__FILE__))
KEYS                   = ::YAML.load(File.open(KEYS_FILE_PATH).read)
# TODO: hard coding for testing to overwrite

def last_dirs(full_paths)
  full_paths.map { |path| path.split('/').last }  
end

describe Catapult::Bootstrap do
  before(:all) do
    ::FileUtils.rm_rf BASE_CONFIG_TARGET_DIR
    ::FileUtils.mkdir_p BASE_CONFIG_TARGET_DIR
    ::FileUtils.rm_rf NEMESIS_DIR
    ::FileUtils.mkdir_p NEMESIS_DIR

    Catapult::Bootstrap::Config.generate_and_write_configurations(KEYS, BASE_CONFIG_TARGET_DIR, NEMESIS_DIR, overwrite: true)
  end

  it { expect(last_dirs(::Dir.glob("#{NEMESIS_DIR}/*"))).to eq(['block-properties-file.properties']) }
  it { expect(last_dirs(::Dir.glob("#{BASE_CONFIG_TARGET_DIR}/*"))).to eq(['peer-node-1', 'rest-gateway-0', 'peer-node-0', 'api-node-0']) }

end
