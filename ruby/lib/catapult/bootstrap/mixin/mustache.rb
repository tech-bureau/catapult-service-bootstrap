require 'mustache'
module Catapult::Bootstrap
  module Mixin
    module Mustache
      def bind_mustache_variables(template, template_attributes_hash)
        ret = ::Mustache.render(template, template_attributes_hash)
        ret.gsub('&#39;',"'") # protection around ::Mustache.render "'" to '&#39;'
      end
    end
  end
end
