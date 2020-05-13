module Catapult::Bootstrap
  class Tools::Nemesis::Nemgen
    class Mosaics
      require_relative('mosaics/element')
      def initialize(nemgen_log)
        @currency_mosaic_id   = Element.id(:currency, nemgen_log)
        @harvesting_mosaic_id = Element.id(:harvesting, nemgen_log)
      end

      def self.parse(nemgen_log)
        new(nemgen_log)
      end

      protected

      attr_reader :currency_mosaic_id, :harvesting_mosaic_id
    end
  end
end
