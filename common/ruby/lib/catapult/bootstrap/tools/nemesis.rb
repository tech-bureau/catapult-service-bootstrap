module Catapult::Bootstrap
  class Tools
    class Nemesis < self
      require_relative('nemesis/linker')
      require_relative('nemesis/nemgen')
    end
  end
end
