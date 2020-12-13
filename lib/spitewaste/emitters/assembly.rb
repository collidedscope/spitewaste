module Spitewaste
  class AssemblyEmitter < Emitter
    def emit io:
      io.puts instructions.map { |i| (i * ' ').rstrip }
    end
  end
end
