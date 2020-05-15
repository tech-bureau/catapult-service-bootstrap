module Catapult::Bootstrap
  class Tools::Nemesis
    class Nemgen < self
      require_relative('nemgen/process_node')
      require_relative('nemgen/mosaics')
      require_relative('nemgen/temp_dir')

      def initialize
        @nemesis_temp_dir = TempDir.new
      end
      private :initialize

      def self.generate_and_write
        new.generate_and_write
      end
      def generate_and_write
        begin
          generate_nemesis_in_temp_dir?
          self.all_node_refs.each { |node_ref| ProcessNode.process?(node_ref, self) }
        ensure
          remove_temp_dir
        end
      end

      # If generate_nemesis_in_temp_dir? called, we must always call remove_temp_dir
      def generate_nemesis_in_temp_dir?
        self.nemesis_temp_dir.generate_nemesis?
      end
      def remove_temp_dir
        self.nemesis_temp_dir.remove_temp_dir
      end

      def temp_data_dir
        @temp_data_dir ||= self.nemesis_temp_dir.seed_dir
      end

      def mosaics
        @mosaics ||= self.nemesis_temp_dir.mosaics
      end

      protected

      attr_reader :nemesis_temp_dir

      NODE_COMPONENT_TYPES = [:peer_node, :api_node]
      NodeRef = Struct.new(:type, :index)
      def all_node_refs
        @all_node_refs ||= NODE_COMPONENT_TYPES.map do |type| 
          cardinality = Global::ComponentCardinaity.send(type)
          (0...cardinality).to_a.map { |index| NodeRef.new(type, index) }
        end.flatten
      end


      # component_userconfig_dir can pick any of the nodes userconfig dirs
      def component_userconfig_dir
        Config.sample_component_userconfig_dir
      end
      
      def block_properties_path
        Config::Nemesis::BlockPropertiesFile.full_path
      end


      private

    end
  end
end

=begin
THis was the bash script
config_form() {
  split=$(echo $1 | sed  's/\(.\)/\1 /g')
  concat=$(printf "%c%c%c%c'" $(echo $split))
  echo "0x${concat::-1}"
}

if [ ! -d /data ]; then
  echo "/data directory does not exist"
  exit 1
fi
if [ ! -d /data/00000 ]; then
  set -e
  echo "running nemgen"
  cd /tmp
  mkdir settings
  mkdir -p seed/public-test/00000
  dd if=/dev/zero of=seed/public-test/00000/hashes.dat bs=1 count=64
  cd settings
  ######## need to run twice and patch the mosaic ids
  # first time to get cat.harvest nad cat.currency
  /usr/catapult/bin/catapult.tools.nemgen  --resources /userconfig/ --nemesisProperties /nemesis/block-properties-file.properties 2> /tmp/nemgen.log
  harvesting_mosaic_id=$(grep "cat.harvest" /tmp/nemgen.log | grep nonce  | awk -F=  '{split($0, a, / /); print a[9]}' | sort -u)
  currency_mosaic_id=$(grep "cat.currency" /tmp//nemgen.log | grep nonce  | awk -F=  '{split($0, a, / /); print a[9]}' | sort -u)

  # second time after replacing values for currencyMosaicId and harvestingMosaicId
  sed -i "s/^harvestingMosaicId = .*/harvestingMosaicId = $(config_form ${harvesting_mosaic_id})/" /userconfig/resources/config-network.properties
  sed -i "s/^currencyMosaicId = .*/currencyMosaicId = $(config_form ${currency_mosaic_id})/" /userconfig/resources/config-network.properties
  /usr/catapult/bin/catapult.tools.nemgen  --resources /userconfig/ --nemesisProperties /nemesis/block-properties-file.properties

  cp -r /tmp/seed/public-test/* /data*
else
  echo "no need to run nemgen"
fi
=end
