class Whitespace
  Ops = {
    "  "       => :push,  " \t "   => :copy, " \t\n"   => :slide, "\n  "    => :label,
    "\n \t"    => :call,  "\n \n"  => :jump, "\n\t "   => :jz,    "\n\t\t"  => :jn,
    " \n\n"    => :pop,   " \n "   => :dup,  " \n\t"   => :swap,  "\t   "   => :add,
    "\t  \t"   => :sub,   "\t  \n" => :mul,  "\t \t "  => :div,   "\t \t\t" => :mod,
    "\t\t "    => :store, "\t\t\t" => :load, "\n\t\n"  => :ret,   "\t\n\t " => :ichr,
    "\t\n\t\t" => :inum,  "\t\n  " => :ochr, "\t\n \t" => :onum,  "\n\n\n"  => :exit
  }

  attr_accessor :stack, :heap, :insns

  def initialize src
    @src, @stack, @heap = src, [], {}
  end

  def parse
    @insns = []
    buf = ''
    while c = @src.slice!(0)
      if insn = Ops[buf << c]
        arg = parse_number if Ops.keys.index(buf) < 8
        @insns << [insn, arg].compact
        buf.clear
        arg = nil
      end
    end

    self
  end

  def parse_number
    bin = @src.slice! 0, @src.index(?\n) + 1
    bin[0] = '-' if bin[0] == ?\t
    bin.tr(" \t", "01").to_i 2
  end

  def interpret
    @jumps = {}
    @insns.each_with_index do |(op, arg), i|
      @jumps[arg] = i if op == :label
    end

    ip, calls = -1, []
    while insn = @insns[ip += 1]
      op, arg = insn
      case op
      when :push  ; @stack << arg
      when :copy  ; @stack << @stack[-1 - arg]
      when :slide ; @stack[-arg - 1, arg] = []
      when :call  ; calls << ip; ip = @jumps[arg]
      when :jump  ; ip = @jumps[arg]
      when :jz    ; ip = @jumps[arg] if @stack.pop == 0
      when :jn    ; ip = @jumps[arg] if @stack.pop < 0
      when :pop   ; @stack.pop
      when :dup   ; @stack << @stack[-1]
      when :swap  ; @stack[-1], @stack[-2] = @stack[-2], @stack[-1]
      when :add   ; @stack << @stack.pop(2).reduce(:+)
      when :sub   ; @stack << @stack.pop(2).reduce(:-)
      when :mul   ; @stack << @stack.pop(2).reduce(:*)
      when :div   ; @stack << @stack.pop(2).reduce(:/)
      when :mod   ; @stack << @stack.pop(2).reduce(:%)
      when :store ; k, v = @stack.pop(2); @heap[k] = v
      when :load  ; @stack << @heap[@stack.pop].to_i
      when :ret   ; ip = calls.pop
      when :ichr  ; @heap[@stack.pop] = (STDIN.getc || -1).ord
      when :inum  ; @heap[@stack.pop] = STDIN.gets.to_i
      when :ochr  ; STDOUT << @stack.pop.chr
      when :onum  ; STDOUT << @stack.pop
      when :exit  ; break
      end
    end
  end

  def run_live insns
    # Hot-load the instructions just after main and before exit.
    @insns.insert 1, *insns
    # That misaligns all our jump targets, so offset them accordingly.
    @jumps.transform_values! { |v| v + insns.size }
    interpret

    # Restore things for the next run.
    @jumps.transform_values! { |v| v - insns.size }
    @insns.slice! 1, insns.size

    [@stack, @heap]
  end
end
