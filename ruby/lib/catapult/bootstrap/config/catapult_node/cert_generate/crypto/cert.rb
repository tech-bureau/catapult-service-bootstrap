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
      # Does the steps to create cert and self-sign it
      #   openssl req -config ca.cnf -keyform PEM -key ca.key.pem -new -x509 -days 7300 -out ca.cert.pem
      # and following if self sign
      #   openssl x509 -in ca.cert.pem  -text -noout
      class Cert < Top
        def initialize(ca_key, cnf_content, self_sign: false)
          @cert_pem = ret_cert_pem(ca_key, cnf_content, self_sign)
          super(self.file_name => @cert_pem)

        end
        
        def self.self_sign(ca_key, cnf_content)
          new(ca_key, cnf_content, self_sign: true)
        end

        attr_reader :cert_pem

        protected

        def file_name
          Global::CertInfo.certificate
        end
        
        private
        
        DAYS = 7300
        def ret_cert_pem(ca_key, cnf_content, self_sign)
          execution_context(ca_key.pem, cnf_content) do |output_file, ca_pem_file, cnf_file|
            execute_command("openssl req -config #{cnf_file.path} -keyform PEM -key #{ca_pem_file.path} -new -x509 -days #{DAYS} -out #{output_file.path}")
            if self_sign
              execute_command("openssl x509 -in #{output_file.path} -text -noout")
            end
            output_file.read
          end
        end

      end
    end
  end
end
