module Framework
  class Root < String

    # @param path [String]
    def initialize(path=Dir.pwd)
      super(path)
      self.freeze
    end

    # @param args [Array<String>]
    # @return [String]
    def join(*args)
      File.join(self, *args)
    end

    def inspect
      to_s
    end

    def to_s
      self
    end
  end
end