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
  class CertGenerate
    class Crypto
      require_relative('crypto/top')
      # top must go first
      require_relative('crypto/cert')
      require_relative('crypto/cnf_file')
      require_relative('crypto/info')
      require_relative('crypto/key')
      require_relative('crypto/request')
      require_relative('crypto/write_to_files')
      
      def initialize(parent)
        @parent = parent
      end
      
      def crypto_info_exists?
        # TODO: right now just one index. logic here if multiple indexs is to return true only if crypto_info_exists for all
        # indexes
        ! self.parent.component_indexes.find do |component_index|
          ! ::File.file?(ca_key_full_path(component_index))
        end
      end
      
      def write_to_files
        self.indexed_info_generated.each_pair do |component_index, info|
          cert_dir_full_path = self.parent.component_cert_dir_full_path(component_index)
          WriteToFiles.write_to_files(cert_dir_full_path, info)
        end
      end
      
      def indexed_keys_generated
        @indexed_keys_generated ||= self.indexed_info_generated.inject({}) do |h, (component_index, info)|
          h.merge(component_index => info.ca_key)
        end
      end
      
      def indexed_keys_existing
        @indexed_keys_existing ||= self.indexed_info_existing.inject({}) do |h, (component_index, info)|
          h.merge(component_index => info.ca_key)
        end
      end
      
      protected
      
      attr_reader :parent
      
      # Indexed by component_index
      def indexed_info_generated
        @indexed_info_generated ||= self.indexed_cert_cnf_files.inject({}) do |h, (component_index, cert_cnf_files)|
          h.merge(component_index => Info::Generated.new(cert_cnf_files))
        end
      end 

      def indexed_info_existing
        @indexed_info_existing ||= self.parent.component_indexes.inject({}) do |h, component_index|
          h.merge(component_index => Info::Existing.new(ca_key_full_path(component_index)))
        end
      end 
                  
      def indexed_cert_cnf_files
        @indexed_cert_cnf_files ||= self.parent.indexed_cert_cnf_files
      end

      private

      def ca_key_full_path(component_index)
        "#{self.parent.component_cert_dir_full_path(component_index)}/#{Global::CertInfo.private_key}"
      end
      
    end
  end
end

=begin
mkdir new_certs && chmod 700 new_certs
touch index.txt

# create CA key
openssl genpkey -out ca.key.pem -outform PEM -algorithm ed25519
openssl pkey -inform pem -in ca.key.pem -text -noout
openssl pkey -in ca.key.pem -pubout -out ca.pubkey.pem

# create CA cert and self-sign it
openssl req -config ca.cnf -keyform PEM -key ca.key.pem -new -x509 -days 7300 -out ca.cert.pem
openssl x509 -in ca.cert.pem  -text -noout


# create node key
openssl genpkey -out node.key.pem -outform PEM -algorithm ed25519
openssl pkey -inform pem -in node.key.pem -text -noout

# create request
openssl req -config node.cnf -key node.key.pem -new -out node.csr.pem
openssl req  -text -noout -verify -in node.csr.pem

### below is done after files are written
# CA side
# create serial
openssl rand -hex 19 > ./serial.dat

# sign cert for 375 days
openssl ca -config ca.cnf -days 375 -notext -in node.csr.pem -out node.crt.pem
openssl verify -CAfile ca.cert.pem node.crt.pem

# finally create full crt
cat node.crt.pem ca.cert.pem > node.full.crt.pem
=end
