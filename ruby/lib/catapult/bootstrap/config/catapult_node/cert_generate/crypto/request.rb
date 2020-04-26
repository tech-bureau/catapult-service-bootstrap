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
module Catapult::Bootstrap
  class Config::CatapultNode::CertGenerate
    class Crypto
      # Does the steps to create request
      #   openssl req -config node.cnf -key node.key.pem -new -out node.csr.pem
      #   openssl req  -text -noout -verify -in node.csr.pem
      class Request < Top
        def initialize(node_key, cnf_content)
          @csr_pem = ret_node_csr_pem(node_key, cnf_content)
          super(self.file_name => @csr_pem)

        end
        
        attr_reader :csr_pem
      
        protected

        def file_name
          Global::CertInfo.node_csr_pem
        end
        
        private

        def ret_node_csr_pem(node_key, cnf_content)
          execution_context(node_key.pem, cnf_content) do |output_file, node_pem_file, cnf_file|
            execute_command("openssl req -config #{cnf_file.path} -key #{node_pem_file.path} -new -out #{output_file.path}")
            execute_command("openssl req -text -noout -verify -in #{output_file.path}")
            output_file.read
          end
        end
        
      end
    end
  end
end

