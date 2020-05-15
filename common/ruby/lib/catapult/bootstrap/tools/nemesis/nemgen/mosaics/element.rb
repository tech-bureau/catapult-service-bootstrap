module Catapult::Bootstrap
  class Tools::Nemesis::Nemgen::Mosaics
    class Element

      def initialize(mosaic_type, nemgen_log)
        @mosaic_type = mosaic_type
        @nemgen_log  = nemgen_log
      end

      def self.id(mosaic_type, nemgen_log)
        new(mosaic_type, nemgen_log).id
      end

      def id
        matches = []
        self.nemgen_log.each_line do |line|
          if line =~ self.match_line_regexp
            matches << $1
          end
        end
        case matches.size
        when 1
          config_form(matches.first)
        when 0
          fail "No match for pattern: #{self.match_line_regexp}"
        else
          fail "Multiple matches for pattern: #{self.match_line_regexp}"
        end
      end

      protected

      attr_reader :mosaic_type, :nemgen_log

      def match_line_regexp
        @match_line_regexp ||= ::Regexp.new("mapping #{self.mosaic} to ([0-9A-F]+) \\(nonce")
      end

      def mosaic
        "#{self.block_property_class.base_namespace}.#{self.mosaic_name}"
      end

      def mosaic_name
        self.block_property_class.mosaic_name.send(self.mosaic_type)
      end

      def block_property_class
        Config::Nemesis::BlockPropertiesFile
      end

      private

      def config_form(raw_form)
        ret = '0x'
        (0...4).each do |offset|
          lower = offset * 4
          ret += "'#{raw_form[lower...lower + 4]}"
        end 
        ret.gsub(/^0x'/, '0x')
      end

    end
  end
end
