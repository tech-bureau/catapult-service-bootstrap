module Catapult::Bootstrap
  class Tools::Nemesis
    class Linker < self
      def initialize(harvest_vrf_directory)
        @harvest_vrf_directory = harvest_vrf_directory
      end

      def link_harvesting_pair(harvesting_pair)
        execute_command(command(harvesting_pair))
      end
      
      protected 
      
      attr_reader :harvest_vrf_directory
      
      def resource_parent_directory
        Catapult::Bootstrap::Config.component_userconfig_dir
      end
      
      private
      
      def command(harvesting_pair)
        "#{self.executable} -r  #{self.resource_parent_directory} --secret=#{harvesting_pair.signing.private} --linkedPublicKey=#{harvesting_pair.vrf.public} --output #{output_file(harvesting_pair)}"
      end

      def output_file(harvesting_pair)
        "#{self.harvest_vrf_directory}/tx#{harvesting_pair.signing.index}.bin"        
      end
    end
  end
end
