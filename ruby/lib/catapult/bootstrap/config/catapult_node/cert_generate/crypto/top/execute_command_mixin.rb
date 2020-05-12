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
    class Crypto::Top
      module ExecuteCommandMixin
        include Mixin::ExecuteCommand

        private

        # block should have argments: output_file, pem_file, cnf_file
        def execution_context(key_pem, cnf_content, &block)
          create_tempfile do |output_file|
            create_tempfile(key_pem) do |pem_file|
              create_tempfile(cnf_content) do |cnf_file|
                block.call(output_file, pem_file, cnf_file)
              end
            end
          end
        end

      end
    end
  end
end
