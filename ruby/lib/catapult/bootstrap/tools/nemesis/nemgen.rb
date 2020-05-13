module Catapult::Bootstrap
  class Tools::Nemesis
    class Nemgen < self
      require_relative('nemgen/temp_dir')
      require_relative('nemgen/mosaics')

      def initialize
        @nemesis_temp_dir = TempDir.new
      end
      private :initialize

      def self.generate_and_write
        nemgen_helper = new
        begin
          nemgen_helper.generate_nemesis_in_temp_dir?
        # TODO: iterate over all the nodes using opy_to_node_data_dir(node_data_dir)
        ensure
          nemgen_helper.remove_temp_dir
        end
      end

      # If generate_nemesis_in_temp_dir? called, we must always call remove_temp_dir
      def generate_nemesis_in_temp_dir?
        self.nemesis_temp_dir.generate_nemesis?
      end
      def remove_temp_dir
        self.nemesis_temp_dir.remove_temp_dir
      end

      def copy_to_node_data_dir(node_data_dir)
      end

      protected

      attr_reader :nemesis_temp_dir
      
      # node_resource_parent_dir can pick any of the nodes userconfig dirs
      SAMPLE_NODE = 'peer-node-0'
      def node_resource_parent_dir
        @node_resource_parent_dir ||=  "#{Directory::BaseConfig.full_path}/#{SAMPLE_NODE}/userconfig/"
      end
      
      def block_properties_path
        Config::Nemesis::BlockPropertiesFile.full_path
      end

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
