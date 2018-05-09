class Catapult::Config
  class SourceTargetPair
    def initialize(filename, source_path)
      @filename    = filename
      @source_path = source_path
    end
    
    attr_reader :filename, :source_path
    
    def self.config_files(config_info_dir_files)
      source_paths = config_info_dir_files.reject { |path| path =~ TEMPLATE_FILE_REGEXP }
      source_paths.map do |source_path|
        filename    = source_path.split('/').last
        new(filename, source_path)
      end
    end
    
    def self.config_templates(config_info_dir_files)
      template_paths = config_info_dir_files.select { |path| path =~ TEMPLATE_FILE_REGEXP }
      template_paths.map do |template_path|
        filename    = template_path.split('/').last.sub(TEMPLATE_FILE_REGEXP, '')
        new(filename, template_path)
      end
    end
    
    TEMPLATE_FILE_REGEXP = /\.mt$/
  end
end


 

