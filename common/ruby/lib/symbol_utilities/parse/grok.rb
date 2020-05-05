require 'grok-pure'
module SymbolUtilities
  module Parse
    class Grok
      BASE_PATTERN_FILE = ::File.expand_path('grok/patterns/base', ::File.dirname(__FILE__))
      
      def initialize
        @grok = ret_initalize_grok_object
      end
      
      def add_patterns_from_file!(path)
        self.grok.add_patterns_from_file(path)
        self
      end

      def add_pattern!(pattern_name, pattern)
        self.grok.add_pattern(pattern_name, pattern)
        self
      end
      
      def match?(input, pattern)
        self.grok.compile("%{#{pattern}}")
        if match = self.grok.match(input)
          match.captures
        end
      end
      
      protected
      
      attr_reader :grok
      
      private
      
      def ret_initalize_grok_object
        grok = ::Grok.new
        grok.add_patterns_from_file(BASE_PATTERN_FILE)
        grok
      end

    end
  end
end
