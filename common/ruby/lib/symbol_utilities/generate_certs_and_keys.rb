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
module SymbolUtilities
  class GenerateCertsAndKeys
    def initialize(node_type, num_nodes: 1)
      @node_type         = node_type.to_sym
      @identity_dir      = Directory.identity
      @num_nodes         = num_nodes
    end

    def self.generate(node_type, num_nodes: 1)
      new(node_type, num_nodes: num_nodes).generate
    end
    def generate
      if self.crypto_info_exists?
        RunTimeVars::CopyKey.run(self.node_type, self.component_keys, identity_dir: self.identity_dir, overwrite: true)
      else
        self.cert_generate.write_to_files
        RunTimeVars::CopyKey.run(self.node_type, self.component_keys, identity_dir: self.identity_dir)
      end
    end

    def component_indexes
      (0..self.num_nodes-1).to_a
    end

    attr_reader :node_type

    def identity_dir_full_path(component_index)
      fail "Currently not implemented: multiple components needing identities" unless component_index == 0
      self.identity_dir
    end

    protected

    attr_reader :identity_dir, :num_nodes

    def crypto_info_exists?
      if @crypto_info_exists.nil?
        @crypto_info_exists = self.cert_generate.crypto_info_exists?
      else
        @crypto_info_exists
      end
    end

    def component_keys
      @component_keys ||= Keys::Component.new(self.keys_handle)
    end

    def keys_handle
      @keys_handle ||= 
        begin
          indexed_keys = (self.crypto_info_exists? ? 
                            self.cert_generate.indexed_keys_existing :
                            self.cert_generate.indexed_keys_generated)
          Keys::Handle.new(self.node_type => indexed_keys)
        end
    end

    def cert_generate
      @cert_generate ||= CertGenerate.new(self)
    end
  end    
end

