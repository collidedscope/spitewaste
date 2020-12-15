module Spitewaste
  class Assembler
    attr_reader :src, :parser, :instructions

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
      @instructions = @parser.instructions
      @src = @parser.src if format == :spitewaste
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
      emitter.new(format == :wsassembly ? @src : @instructions, **options).emit io: io
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
