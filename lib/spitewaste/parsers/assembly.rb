module Spitewaste
  class AssemblyParser
    OperatorError = Class.new Exception
    SyntaxError = Class.new Exception

    attr_reader :instructions, :error

    def initialize program, **options
      @program = program
    end

    def parse
      mnemonics = OPERATORS_M2T.keys
      @instructions = @program.lines.map.with_index(1) { |insn, no|
        op, arg = insn.split

        unless i = mnemonics.index(op = op.to_sym)
          @error = [:unknown, op, [i, 1]]
          raise OperatorError, "unknown operator '#{op}' (line #{no})", []
        end

        bad_arg = -> kind {
          @error = [kind, op, [i, 1]]
          raise SyntaxError, "#{kind} argument for #{op} operator (line #{no})", []
        }

        bad_arg[:missing] if i < 8 && !arg
        bad_arg[:invalid] if i < 8 && !arg[/^-?\d+$/]
        bad_arg[:useless] if i > 7 && arg

        [op, arg && arg.to_i]
      }
    end
  end
end
