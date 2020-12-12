module Spitewaste
  class WhitespaceEmitter < Emitter
    def emit io:
      instructions.each do |op, arg|
        io.write OPERATORS_M2T[op]
        io.write self.class.encode(arg) if arg
      end
    end

    def self.encode n
      (n < 0 ? ?\t : ' ') + n.abs.to_s(2).tr('01', " \t") + ?\n
    end
  end
end
