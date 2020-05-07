module Catapult::Bootstrap
  class Tools::Nemesis
    class Link < self
      def initialize(harvest_vrf_directory)
        @harvest_vrf_directory = harvest_vrf_directory
      end

      def link_harvesting_pair(harvesting_pair)
        require 'byebug'; byebug
        execute_command(command(harvesting_pair))
      end
      
      protected 
      
      attr_reader :harvest_vrf_directory
      
      def resource_parent_directory
        Catapult::Bootstrap::Config.node_resource_parent_dir
      end
      
      private
      
      def command(harvesting_pair)
        "#{self.executable} -r  #{resource_parent_directory} --secret=#{harvesting_pair.base.private} --linkedPublicKey=#{harvesting_pair.vrf.public} --output #{output_file(harvesting_pair)}"
      end

      def output_file(harvesting_pair)
        "#{self.harvest_vrf_directory}/tx#{harvesting_pair.base.index}.bin"        
      end
    end
  end
end
