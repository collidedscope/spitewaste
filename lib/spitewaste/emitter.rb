module Spitewaste
  class Emitter
    attr_reader :instructions, :options

    def initialize instructions, **options
      @instructions = instructions
      @options = options
    end
  end
end
