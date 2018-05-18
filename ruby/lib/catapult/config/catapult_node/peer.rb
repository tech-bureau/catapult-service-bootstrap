#    Copyright 2018 Tech Bureau, Corp
# 
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
# 
#        http://www.apache.org/licenses/LICENSE-2.0
# 
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.
module Catapult
  class Config::CatapultNode
    class Peer
      def initialize(type, index)
        @type         = type
        @index        = index
        @host_address = Global.component_address(type, index)
        @host         = self.class.host(type, index)
        @port         = self.class.port(type)
        @name         = self.class.name(type, index)
      end
      private :initialize
      
      attr_reader :type, :index, :host, :host_address, :port, :name
      
      TYPES = [:api_node, :peer_node]
      def self.all_peers(input_attributes)
        peers = []
        TYPES.each do |type|
          (0..Config.cardinality(type)-1).to_a.each do |index|
            peers << Peer.new(type, index)
          end
        end
        peers
      end
      
      def self.host(type, index)
        Global.component_address(type, index)
      end
      
      def self.name(type, index)
        host(type, index)
      end
      
      def self.port(type)
        Global::CatapultPort.peer_port(type)
      end
        
    end
  end
end
