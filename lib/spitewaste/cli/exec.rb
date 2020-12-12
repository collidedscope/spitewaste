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

  def exec file = '/dev/stdin'
    fmt = SpitewasteCLI.validate_format options

    raise LoadError, "No such file '#{file}'", [] unless File.exists? file

    opts = options.dup # options is frozen
    if opts[:symbol_file] == '%'
      opts[:symbol_file] = SpitewasteCLI.make_cache_path file
    end

    path =
      if File.extname(file) != '.ws'
        io = Tempfile.new
        as = Spitewaste::Assembler.new File.read(file), format: fmt, **opts
        as.assemble! format: :whitespace, io: io
        io.tap(&:close).path
      else
        file
      end

    cmd = options[:interpreter].split
    cmd.map! { |c| c == '%' ? path : c }
    Kernel.exec *cmd
  end
end
