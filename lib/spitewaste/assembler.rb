module Spitewaste
  class Assembler
    attr_reader :parser

    def initialize program, **options
      format = options[:format]
      format ||= Spitewaste.guess_format program
      unless %i[whitespace wsassembly assembly spitewaste].include? format
        raise ArgumentError, "unknown format for parse: #{format}"
      end

      parser =
        case format
        when :whitespace
          WhitespaceParser
        when :assembly
          AssemblyParser
        else # used for both Spitewaste and Whitespace assembly
          SpitewasteParser
        end

      @parser = parser.new(program, **options).tap &:parse
      @src = @parser.src if format == :spitewaste
      @instructions = @parser.instructions
    end

    def assemble! format:, io: STDOUT, **options
      unless %i[whitespace wsassembly assembly codegen image].include? format
        raise ArgumentError, "unknown format for emit: #{format}"
      end

      emitter =
        case format
        when :whitespace
          WhitespaceEmitter
        when :wsassembly
          WSAssemblyEmitter
        when :codegen
          CodegenEmitter
        when :image
          ImageEmitter
        else
          AssemblyEmitter
        end

      # Worthwhile optimizations can only be done if we have a symbol table.
      optimize! if parser.is_a? SpitewasteParser

      src = format == :wsassembly ? @src : @instructions
      emitter.new(src, **options).emit io: io
    end

    def optimize_constant_pow op, arg
      pow = parser.symbol_table['pow']

      case [*@instructions[@ip - 2, 2], op, arg]
        in [[:push, base], [:push, exp], :call, ^pow]
        @instructions[@ip - 2, 3] = [[:push, base ** exp]]

        in [[:push, base], [:dup, _], :call, ^pow]
        @instructions[@ip - 2, 3] = [[:push, base ** base]]

        else nil
      end
    end

    def optimize_constant_strpack op, arg
      strpack = parser.symbol_table['strpack']

      if [op, arg] == [:call, strpack]
        # naively assume the null terminator arrived on the stack via push
        start = @instructions[0, @ip].rindex [:push, 0]
        between = @instructions[start + 1...@ip]

        bytes = []
        return unless between.all? { |op, arg| op == :push && bytes << arg }

        packed = bytes.reverse.zip(0..).sum { |b, e| b * 128 ** e }
        @instructions[start..@ip] = [[:push, packed]]
        @ip = start + 1
      end
    end

    def optimize!
      @ip = 0
      while (op, arg = @instructions[@ip])
        next if optimize_constant_pow op, arg
        next if optimize_constant_strpack op, arg
        @ip += 1
      end
    end

    def try_elide_main
      if @instructions.first == [:label, 0]
        @instructions.shift unless @instructions.any? { |op, arg|
          arg == 0 && %i[jump jz jn call].include?(op)
        }
      end
    end
  end
end
