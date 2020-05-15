module Catapult::Bootstrap
  class Directory
    class Nemesis < self
    end
    class BaseConfig < self
    end
    class BaseData < self
    end

    def self.set!(full_path)
      @base = full_path
    end

    def self.full_path
      @base || fail("set! has not been called")
    end
  end
end
