module Catapult
  class Config::CatapultNode
    class TemplateAttributes
      class PerIndex
        PEER_CONFIG_API_PORT = 7901
        def initialize(parent, index)
          @parent = parent
          @index  = index
          @type   = parent.type
        end
        
        def hash
          {
            harvesting_is_on: self.harvesting_is_on?,
            harvest_key: self.harvest_key?,
            mongo_host: self.mongo_host_for_api_node, # just used when there is an api host
            bootkey: self.private_key,
            api_port: PEER_CONFIG_API_PORT,
            port: Peer.port(self.type),
            host: Peer.host(self.type, self.index),
            friendly_name: Peer.name(self.type, self.index),
          }
        end
        
        protected
        
        attr_reader :parent, :index, :type
        
        def mongo_host_for_api_node
          Global.mongo_host
        end

        def harvesting_is_on?
            # TODO: simple strategy that just turns on harvesting for first peer node
          self.type == :peer_node and self.index  == 0
        end
        
        def harvest_key?
          harvest_key if harvesting_is_on? 
        end
        
        def private_key
            self.parent.component_keys.get_key(:private, self.type, self.index)
        end
        
        private
        
        def harvest_key
          fail "Only should have harvesting on peer_node" unless self.type  == :peer_node 
          self.parent.harvest_keys[self.index] || fail("Do not have a harvest key for index #{self.index}")
        end
        
      end
    end
  end        
end


 

