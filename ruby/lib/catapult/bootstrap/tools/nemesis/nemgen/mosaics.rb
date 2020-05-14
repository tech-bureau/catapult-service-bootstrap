module Catapult::Bootstrap
  class Tools::Nemesis::Nemgen
    class Mosaics
      require_relative('mosaics/config_network')
      require_relative('mosaics/element')

      def initialize(nemgen_log)
        @currency_mosaic_id   = Element.id(:currency, nemgen_log)
        @harvesting_mosaic_id = Element.id(:harvesting, nemgen_log)
      end

      def self.parse(nemgen_log)
        new(nemgen_log)
      end

      def update_config_network_file(node_resource_parent_dir)
        ConfigNetwork.update_file(node_resource_parent_dir, self)
      end

      attr_reader :currency_mosaic_id, :harvesting_mosaic_id
    end
  end
end
