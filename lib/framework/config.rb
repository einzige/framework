module Framework
  class Config < Hash

    # @param hash [Hash]
    def initialize(hash)
      super()
      hash.each_pair { |k, v| self[k] = v }
    end

    # @param k [Symbol, String]
    def [](k)
      super(k.to_sym)
    end

    # @param k [Symbol, String]
    # @param v
    def []=(k,v)
      super(k.to_sym, wrap(v))
    end

    def method_missing(method_name, *args, &block)
      case args.count
      when 0
        self[method_name]
      when 1
        mname = method_name.to_s

        if mname.end_with?('=')
          self[mname.sub('=', '').to_sym] = *args
        else
          super
        end
      else
        super
      end
    end

    private

    def wrap(v)
      case v
      when Hash
        self.class.new(v)
      else
        v
      end
    end
  end
end
