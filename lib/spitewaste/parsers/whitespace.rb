module Spitewaste
  class WhitespaceParser
    SyntaxError = Class.new Exception

    attr_reader :instructions, :error

    def initialize program, **options
      @tokens = program.delete "^\s\t\n" # Remove comments.
    end

    def parse
      @instructions = []
      @line = @column = 1
      operator_buffer = ''
      mnemonics = OPERATORS_M2T.keys

      while token = @tokens.slice!(0)
        operator_buffer << token
        if @operator = OPERATORS_T2M[operator_buffer]
          argument = parse_number if mnemonics.index(@operator) < 8
          @instructions << [@operator, argument]
          operator_buffer.clear
          argument = nil
        end

        if OPERATORS_T2M.none? { |tokens,| tokens.start_with? operator_buffer }
          @error = [:illegal, operator_buffer, [@line, @column]]
          raise SyntaxError,
            "illegal token sequence: #{operator_buffer.inspect} " +
            "(line #@line, column #@column)"
        end

        if token == ?\n
          @line, @column = @line + 1, 1
        else
          @column += 1
        end
      end
    end

    def parse_number
      unless end_of_number = @tokens.index(?\n)
        @column += @tokens.size
        @error = [:number, @operator, [@line, @column]]
        raise SyntaxError,
          "found EOF before end of number for #@operator operator " +
          "(line #@line, column #@column)"
      end

      digits = @tokens.slice! 0, end_of_number + 1

      raise SyntaxError,
        "too few digits in number for #@operator operator " +
        "(line #@line, column #@column)" if digits.size <3

      digits[0] = ?- if digits[0] == ?\t
      digits.tr("\s\t", '01').to_i 2
    end
  end
end
