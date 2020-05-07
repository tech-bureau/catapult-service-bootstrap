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
module Catapult::Bootstrap
  class Config
    class Nemesis
      require_relative('nemesis/block_properties_file')
      require_relative('nemesis/harvest_vrf_files')

      def initialize(keys_handle, nemesis_dir)
        @keys_handle = keys_handle
        @nemesis_dir = nemesis_dir
      end
      private :initialize

      def self.generate_and_write_files(keys_handle, nemesis_dir)
        HarvestVrfFiles.generate_and_write(keys_handle, nemesis_dir)
        BlockPropertiesFile.generate_and_write(keys_handle, nemesis_dir)
      end
      
      def self.generate_and_write(keys_handle, nemesis_dir)
        new(keys_handle, nemesis_dir).generate_and_write
      end
      
      def generate_and_write
        fail "Concrete generate_and_write method needs to be written for '#{self.class}'"
      end

      protected

      attr_reader :keys_handle, :nemesis_dir

      def nemesis_keys_info
        Config::Keys::Nemesis.new(self.keys_handle)
      end
      
      HARVEST_VRF_SUBDIRECTORY = 'vrf'
      def harvest_vrf_directory
        @harvest_vrf_directory ||= "#{self.nemesis_dir}/#{HARVEST_VRF_SUBDIRECTORY}"
      end

    end
  end
end
