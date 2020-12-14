require 'tempfile'

class SpitewasteCLI
  desc 'exec [OPTIONS] FILE',
    'Execute a Whitespace program using the specified interpreter.'

  option :interpreter,
    desc: 'the command to execute for interpretation, with % in place of the filename',
    banner: 'COMMAND',
    default: 'ws %',
    aliases: '-i'

  option :symbol_file,
    banner: 'FILE',
    desc: 'a file to write the symbol table to (intended for use by other tools, namely Spiceweight)
- use % to write to $HOME/.cache/spitewaste directory, where Spiceweight knows to look',
    aliases: '-s'

  def exec input = '/dev/stdin'
    fmt = SpitewasteCLI.validate_format options

    raise LoadError, "No such file '#{input}'", [] unless File.exists? input

    opts = options.dup # options is frozen
    if opts[:symbol_file] == '%'
      opts[:symbol_file] = SpitewasteCLI.make_cache_path input
    end

    if File.extname(input) != '.ws'
      io = Tempfile.new
      as = Spitewaste::Assembler.new File.read(input), format: fmt, **opts
      as.assemble! format: :whitespace, io: io
      input = io.tap(&:close).path
    end

    cmd = options[:interpreter].split
    cmd.map! { |c| c == '%' ? input : c }
    Kernel.exec *cmd
  end
end
