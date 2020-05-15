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
      # Does the steps
      #   openssl genpkey -out key.pem -outform PEM -algorithm ed25519
      #   openssl pkey -inform pem -in key.pem -text -noout
      #   openssl pkey -in key.pem -pubout -out pubkey.pem
      class Key < Top
        def initialize(private_key_name: nil, public_key_name: nil)
          generate_key_info!
          # generate_key_info! has to go first
          super(ret_file_name_content_hash(private_key_name, public_key_name))
        end
        
        attr_reader :pem, :public_pem, :private_key, :public_key

        private

        def ret_file_name_content_hash(private_key_name, public_key_name)
          hash = {}
          hash.merge!(private_key_name => self.pem) if private_key_name
          hash.merge!(public_key_name => self.public_pem) if public_key_name
          hash
        end

        def generate_key_info!
          create_tempfile do |pem_file|
            command_string = "openssl genpkey -out #{pem_file.path} -outform PEM -algorithm #{self.algorithm}"
            execute_command(command_string)
            @pem = pem_file.read
            @public_pem  = ret_public_pem(pem_file.path)
            generate_key_pair!(pem_file.path)
          end
        end
        
        def ret_public_pem(pem_file_path)
          create_tempfile do |public_pem_file|
            execute_command("openssl pkey -in #{pem_file_path} -pubout -out #{public_pem_file.path}")
            public_pem_file.read
          end
        end
        
        def generate_key_pair!(pem_file_path)
          stdout = execute_command("openssl pkey -inform pem -in #{pem_file_path} -text -noout")
          parsed_output = parse_to_get_key_pair(stdout)
          @private_key = parsed_output.private_key
          @public_key  = parsed_output.public_key
        end
        
        # The function parse_to_get_key_pair gets stdout_form in form
        #ED25519 Private-Key:
        #priv:
        #   43:fa:be:f0:cb:19:de:42:b5:96:d2:93:49:25:cb:
        #   db:39:60:d6:3d:38:0e:68:1c:fb:32:cc:7b:78:00:
        #   5d:da
        #pub:
        #    2f:18:b1:98:79:bb:48:db:0a:d2:5c:2a:e8:d9:d6:
        #    39:67:05:92:c4:da:cc:fd:92:7d:43:0f:8b:4b:f4:
        #    1c:1e
        KeyPair = Struct.new(:private_key, :public_key)
        def parse_to_get_key_pair(stdout_form)
          private_key = ''
          public_key  = ''
          reached     = {}
          stdout_form.each_line do |line|
            line.chomp!
            # Order is important 
            if line =~ /priv:/
              reached[:priv] = true
            elsif line =~ /pub/
              reached[:pub] = true
            elsif reached[:pub]
              public_key += line.gsub(' ','')
            elsif reached[:priv]
              private_key += line.gsub(' ','')
            end
          end
          fail "Error parsing PEM file to produce private and public keys" if private_key.empty? or public_key.empty?
          KeyPair.new(format_key(private_key), format_key(public_key))
        end

        def format_key(key)
          key.gsub(':', '')
        end

      end
    end
  end
end

