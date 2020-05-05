module SymbolUtilities
  class PeersConfig
    class RemoteStore < self
      include Aux::Mixin::NetHttp

      def install
        write_peer_config(get_peers_config)
      end

      protected

      def s3_file_http_path
        @s3_file_http_path ||= convert_to_http_form(self.s3_peers_file)
      end     

      def s3_peers_file
        @s3_peers_file ||= ENV['S3_PEERS_FILE'] || fail("Env var S3_PEERS_FILE is not set")
      end     
      private

      def get_peers_config
        get_peers_config_from_s3
      end

      def get_peers_config_from_s3
        begin
          net_http_get(self.s3_file_http_path)
        rescue NetHttpError => e
          if e.response_code? == '403'
            EMPTY_PEER_LIST
          else
            fail e
          end
        end
      end

      def convert_to_http_form(s3_form_path)
        if s3_form_path =~ ::Regexp.new('^s3://([^/]+)/(.+$)')
          bucket = $1
          path = $2
          "https://#{bucket}.s3.amazonaws.com/#{path}"
        else
          fail "Unexpecetd s3 path: #{s3_form_path}"
        end
      end

      EMPTY_PEER_LIST =<<peerlist
{
  "_info": "this file contains a list of peer_node peers",
  "knownPeers": [
  ]
}
peerlist
    end
  end
end



