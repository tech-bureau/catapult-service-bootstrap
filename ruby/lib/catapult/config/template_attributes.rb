module DTKModule
  module Catapult
    class Config
      class TemplateAttributes
        def initialize(dtk_all_attributes)
          @dtk_all_attributes = dtk_all_attributes
        end
        
        def hash(_index)
          DTK.fail_if_not_concrete(self)
        end
        
        protected
        
        attr_reader :dtk_all_attributes
      end
    end
  end
end

