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
  class Config::Nemesis
    class HarvestVrfFiles < self
      def generate_and_write 
        create_or_reset_vrf_directory
        create_vrf_files
      end

      private

      def create_or_reset_vrf_directory
        ::FileUtils.rm_rf self.harvest_vrf_directory
        ::FileUtils.mkdir_p self.harvest_vrf_directory

      end

      def create_vrf_files
        nemesis_linker_tool = Tools::Nemesis::Linker.new(self.harvest_vrf_directory)
        nemesis_keys_info.harvesting_pairs_array.each do |harvesting_pair|
          nemesis_linker_tool.link_harvesting_pair(harvesting_pair)
        end
      end
      
    end
  end
end
