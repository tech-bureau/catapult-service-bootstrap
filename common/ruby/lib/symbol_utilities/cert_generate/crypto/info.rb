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
  class CertGenerate::Crypto
    class Info
      class Existing < self
        def initialize(ca_key_full_path)
          @ca_key = Key.read_ca_key_from_cert_dir(ca_key_full_path, self.ca_key_params)
        end
        attr_reader :ca_key
      end

      class Generated < self
        def initialize(cert_cnf_files)
          ca_cnf_content   = cert_cnf_files[:ca_cnf].content
          node_cnf_content = cert_cnf_files[:node_cnf].content

          @ca_key           = Key.new(self.ca_key_params)
          @ca_cert          = Cert.self_sign(@ca_key, ca_cnf_content)
          @node_key         = Key.new(self.node_key_params)
          @node_request     = Request.new(@node_key, node_cnf_content)
          @ca_cnf           = CnfFile.new(ca_cnf_content, Global::CertInfo.ca_cnf)
          @node_cnf         = CnfFile.new(node_cnf_content, Global::CertInfo.node_cnf)
        end

        Fields = [:ca_key, :ca_cert, :node_key, :node_request, :ca_cnf, :node_cnf]
        attr_reader *Fields
      end

      protected
      
      def ca_key_params
        { private_key_name: Global::CertInfo.private_key, public_key_name: Global::CertInfo.public_key }
      end

      def node_key_params
        { private_key_name: Global::CertInfo.node_private_key, public_key_name: Global::CertInfo.node_public_key }
      end

    end
  end
end

