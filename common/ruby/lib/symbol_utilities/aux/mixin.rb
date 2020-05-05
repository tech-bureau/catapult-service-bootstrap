require 'net/http'
require 'mustache'
module SymbolUtilities
  module Aux
    module Mixin
      module Mustache
        def mustache_render(template, vars)
          ::Mustache.render(template, vars)
        end
      end

      module NetHttp

        def net_http_get(path)
          uri = ::URI.parse(path)
          ::Net::HTTP.start(uri.host) do |http|
            response = http.get(uri.path)
            case response.code
            when '200' 
              ret = response.body
            else
              fail NetHttpError.new(response_code: response.code)
            end
          end
        end

      end
    end
  end

  class NetHttpError < ::StandardError
    def initialize(response_code: nil)
      error_message = "net http error"
      error_message << " with code: #{response_code}" if response_code
      super(error_message)
      @response_code = response_code
      def response_code?
        @response_code
      end
    end
  end
end
