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
      # Does the steps to 
      #   write out base files
      #   create serial
      #     openssl rand -hex 19 > ./serial.dat
      #   sign cert for 375 days
      #     mkdir new_certs && chmod 700 new_certs
      #     touch index.txt
      #     openssl ca -config ca.cnf -days 375 -notext -in node.csr.pem -out node.crt.pem
      #     openssl verify -CAfile ca.cert.pem node.crt.pem
      #   create full crt
      #     cat node.crt.pem ca.cert.pem > node.full.crt.pem
      class WriteToFiles
        include Top::ExecuteCommandMixin

        def initialize(cert_dir_full_path, info)
          @cert_dir_full_path = cert_dir_full_path
          @info               = info
        end
        private :initialize

        def self.write_to_files(cert_dir_full_path, info)
          new(cert_dir_full_path, info).write_to_files
        end

        def write_to_files
          make_cert_dir
          create_serial
          write_base_files
          sign_cert
          create_full_cert
        end

        protected

        attr_reader :cert_dir_full_path, :info
      
        ATTRIBUTES = [:ca_cnf, :certificate, :database_file, :new_certs_dir, :node_csr_pem, :node_crt_pem, :node_full_crt_pem, :serial_file]

        def method_missing(method, *args)
          ATTRIBUTES.include?(method) ? Global::CertInfo.send(method) : super
        end
        
        def respond_to?(method)
          ATTRIBUTES.include?(method) or super
        end

        private

        def make_cert_dir
          ::FileUtils.mkdir_p self.cert_dir_full_path
        end

        def write_base_files
          Crypto::InfoFields.each do |field|
            self.info.send(field).file_name_content_hash.each_pair do | file_name, content | 
              write_file(content, file_name)
            end
          end
        end

        RAND_NUM = 19
        def create_serial
          chdir_to_execute do
            execute_command("openssl rand -hex #{RAND_NUM} > #{self.serial_file}")
          end
        end

        DAYS = 375
        def sign_cert
          chdir_to_execute do
            make_new_certs_dir
            touch_database_files
            execute_command("openssl ca -batch -config #{self.ca_cnf} -days #{DAYS} -notext -in #{self.node_csr_pem} -out #{self.node_crt_pem}")
            stdout = execute_command("openssl verify -CAfile #{self.certificate} #{self.node_crt_pem}")
            check_verify_command(stdout)
          end
        end

        def create_full_cert
          chdir_to_execute do
            execute_command("cat #{self.node_crt_pem} #{self.certificate} > #{self.node_full_crt_pem}")
          end
        end

        def make_new_certs_dir
          ::FileUtils.mkdir_p self.new_certs_dir
          ::FileUtils.chmod 0700, self.new_certs_dir
        end          

        def touch_database_files
          ::FileUtils.touch  self.database_file
          ::FileUtils.touch  "#{self.database_file}.attr"
        end

        def check_verify_command(stdout)
          unless stdout =~ ::Regexp.new("#{self.node_crt_pem}: OK")
            fail "The command openssl verify failed"
          end
        end

        def chdir_to_execute(&block)
          ::Dir.chdir(self.cert_dir_full_path) { block.call }
        end
        
        def write_file(content, file_name)
          ::File.open("#{self.cert_dir_full_path}/#{file_name}", 'w') { |f| f << content }
        end


=begin
        def new_certs_dir
          Global::CertInfo.new_certs_dir
        end

        def serial_file
          Global::CertInfo.serial_file
        end

        def database_file
          Global::CertInfo.database_file
        end

        def ca_cnf
          Global::CertInfo.ca_cnf
        end

        def node_csr_pem
          Global::CertInfo.node_csr_pem
        end

        def node_crt_pem
          Global::CertInfo.node_crt_pem
        end

        def certificate
          Global::CertInfo.certificate
        end

        def node_full_crt_pem
          Global::CertInfo.node_full_crt_pem
        end
=end
      end
    end
  end
end
