module SymbolUtilities
  module Directory

    def self.set_base!(full_path)
      @base = full_path
    end
    def self.base
      @base || fail("set_base! has not been called")
    end

    def self.set_identity!(full_path)
      @identity = full_path
    end
    def self.identity
      @identity || fail("set_identity! has not been called")
    end
  end

end
