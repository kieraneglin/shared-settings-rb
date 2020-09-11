module SharedSettings
  class Configuration
    def initialize
      @default = -> { raise ArgumentError, 'Default configuration must be set' }
    end

    def default(&block)
      if block_given?
        @default = block
      else
        @default.call
      end
    end
  end
end
