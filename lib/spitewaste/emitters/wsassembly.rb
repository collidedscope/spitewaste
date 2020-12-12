module Spitewaste
  class WSAssemblyEmitter < Emitter
    def emit io:
      io.puts @instructions # actually just preprocessed Spitewaste
    end
  end
end
