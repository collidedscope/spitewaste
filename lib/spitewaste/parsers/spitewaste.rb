require 'json'
require 'set'
require_relative 'fucktional'

module Spitewaste
  LIBSPW = File.expand_path '../libspw', __dir__

  class SpitewasteParser
    NameError = Class.new Exception

    INSTRUCTIONS = /(\S+):|(\b(#{OPERATORS_M2T.keys * ?|})\s+(-?\d\S*)?)/
    SPECIAL_INSN = /(call|jump|jz|jn)\s+(\S+)/

    attr_reader :src, :instructions, :error

    def initialize program, **options
      @src = program.dup
      @macros = {}
      @symbol_file = options['symbol_file']

      preprocess!
      eliminate_dead_code! unless options[:keep_dead_code]
    end

    def parse
      @instructions = []

      # first-come, first-served mapping from label names to auto-incrementing
      # indices starting from 0; it would be nice if names could round-trip,
      # but even encoding short ones would result in unpleasantly wide code.
      @symbol_table = Hash.new { |h, k| h[k] = h.size }
      @src.scan(/(\S+):/) { @symbol_table[$1] } # populate label indices
      File.write @symbol_file, @symbol_table.to_json if @symbol_file

      special = @src.scan SPECIAL_INSN
      @src.scan INSTRUCTIONS do |label, _, operator, arg|
        next @instructions << [:label, @symbol_table[label]] if label

        if %i[call jump jz jn].include? operator = operator.to_sym
          arg = @symbol_table[special.shift[1]]
        else
          if OPERATORS_M2T.keys.index(operator) < 8 && !arg
            raise "missing arg for #{operator}"
          elsif arg
            begin
              arg = Integer arg
            rescue ArgumentError
              raise "invalid argument '#{arg}' for #{operator}"
            end
          end
        end

        @instructions << [operator, arg]
      end
    end

    private

    def preprocess!
      resolve_imports
      seed_prng if @seen.include? 'random'
      resolve_strings
      remove_comments
      add_sugar
      fucktionalize
      propagate_macros
    end

    def resolve_imports
      @seen = Set.new

      # "Recursively" resolve `import L (...)` statements with implicit include
      # guarding. Each chunk of imports is appended to the end of the current
      # source all at once to prevent having to explicitly jump to the actual
      # start of the program. Some care must be taken to ensure that the final
      # routine of one library won't inadvertently "flow" into the next.
      while @src['import']
        imports = []
        @src.gsub!(/import\s+(\S+).*/) {
          imports << resolve($1) if @seen.add? $1
          '' # remove import statement
        }
        @src << imports.join(?\n)
      end
    end

    def resolve path
      library = path[?/] ? path : File.join(LIBSPW, path)
      File.read "#{library}.spw"
    end

    def seed_prng
      @src.prepend "push $seed,#{rand 2**31} store $seed = -9001"
    end

    def resolve_strings
      @src.gsub!(/"([^"]*)"/m) {
        [0, *$1.reverse.bytes] * ' push ' + ' :strpack'
      }
    end

    def remove_comments
      @src.gsub!(/;.*/, '')
    end

    def add_sugar
      # `:foo` = `call foo`
      @src.gsub!(/:(\S+)/, 'call \1')
      # character literals
      @src.gsub!(/'(.)'/) { $1.ord }
      # quick push (`push 1,2,3` desugars to individual pushes)
      @src.gsub!(/push \S+/) { |m| m.split(?,) * ' push ' }
    end

    def gensym
      (@sym ||= ?`).succ!
    end

    def fucktionalize
      # Iteratively remove pseudo-fp calls until we can't to allow nesting.
      1 while @src.gsub!(/(#{FUCKTIONAL.keys * ?|})\s*\((.+?)\)/m) do
        FUCKTIONAL[$1] % [gensym, $2]
      end
    end

    def propagate_macros
      # Macros are write-once, allowing user code to customize the special
      # values that get used to drive certain behavior in the standard library.
      @src.gsub!(/(\$\S+)\s*=\s*(.+)/) { @macros[$1] ||= $2; '' }
      @src.gsub!(/(\$\S+)/) { @macros[$1] || raise("no macro '#{$1}'") }
    end

    def eliminate_dead_code!
      tokens = @src.split

      # We need an entry point whence to begin determining which routines
      # are never invoked, but Whitespace programs aren't required to start
      # with a label. Here, we add an implcit "main" to the beginning of the
      # source unless it already contains an explicit entry point. TODO: better?
      start = tokens[0][/(\S+):/, 1] || 'main'
      tokens.prepend "#{start}:" unless $1

      # Group the whole program into subroutines to facilitate the discovery
      # of code which can be safely removed without affecting its behavior.
      subroutines = {}
      while label = tokens.shift
        sublen = tokens.index { |t| t[/:$/] } || tokens.size
        subroutines[label.chop] = tokens.shift sublen
      end

      # A subroutine may indirectly depend on the one immediately after by
      # "flowing" into it; we assume this is the case if the subroutine's final
      # instruction isn't one of {jump, jz, jn, exit, ret}.
      flow = subroutines.each_cons(2).reject { |(_, tokens), _|
        tokens.last(2).any? { |t| %w[jump jz jn exit ret].include? t }
      }.map{ |pair| pair.map &:first }.to_h

      alive = Set.new
      queue = [start]
      until queue.empty?
        # Bail early if the queue is empty or we've already handled this label.
        next unless label = queue.shift and alive.add? label

        unless subroutines[label]
          raise NameError, "can't branch to '#{label}', no such label"
        end

        # Naively(?) assume that subroutines hit all of their branch targets.
        branches = subroutines[label].each_cons(2).select { |insn, _|
          %w[jump jz jn call].include? insn
        }.map &:last

        # Check dependencies for further dependencies.
        queue.concat branches, [flow[label]]
      end

      # warn alive.grep_v(/^_/).sort_by(&:upcase).inspect
      @src = subroutines.filter_map { |label, instructions|
        "#{label}: #{instructions * ' '}" if alive.include? label
      } * ?\n + ' ' # trailing space required for regex reasons!
    end
  end
end
