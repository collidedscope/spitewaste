module Spitewaste
  class AssemblyEmitter < Emitter
    def emit io:
      io.puts instructions.map { (_1 * ' ').rstrip }
    end
  end
end
