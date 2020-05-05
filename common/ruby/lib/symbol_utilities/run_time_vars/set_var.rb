module SymbolUtilities
  class RunTimeVars
    class SetVar < self
      def self.run
        files_content = {}
        self.elements.each { |el| el.update_files_content!(files_content) }
        write_to_file(files_content)
      end

      def update_files_content!(files_content)
        # alias
        if value = self.component_config.value?
          self.fqdn_target_paths.each do |target_path|
            target_content = files_content[target_path] ||= ::File.open(target_template_path(target_path)).read
            target_content.gsub!(self.name, "#{value}") 
          end
        end
        files_content
      end

      protected

      def fqdn_target_paths 
        @fqdn_target_paths ||= self.targets.map { | target | self.class.fqdn(target) }
      end

      private
      
      TEMPLATE_EXTENSION = 'template'
      
      def target_template_path(fqdn_target_path)
        "#{fqdn_target_path}.#{TEMPLATE_EXTENSION}"
      end

      def self.write_to_file(files_content)
        files_content.each_pair do |target_path, target_content|
          # TODO: not doing any chmod
          ::File.open(target_path, 'w') { |f| f << target_content }
        end
      end

    end
  end
end


                            
