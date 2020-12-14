class SpitewasteCLI
  desc 'convert [OPTIONS] INPUT OUTPUT',
    'Convert a Whitespace program from one format to another.'
  long_desc <<DESC
OUTFMT is one of:
	{ws, whitespace} for Whitespace
	{wsa, wsassembly} for Whitespace assembly (preprocessed Spitewaste)
	{asm, assembly} for straight-line Whitespace opcodes
	{cpp, codegen} for C++ (no compilation)
defaults to the extension of OUTPUT
DESC

  option :output_format,
    banner: 'OUTFMT',
    desc: 'the format to convert the input to',
    aliases: '-o'

  option :symbol_file,
    banner: 'FILE',
    desc: 'a file to write the symbol table to (intended for use by other tools, namely Spiceweight)
- use % to write to $HOME/.cache/spitewaste directory, where Spiceweight knows to look',
    aliases: '-s'

  shared_options

  def convert input = '/dev/stdin', output = '/dev/stdout'
    ext = File.extname output
    Kernel.exec 'spw', 'image', input, output if ext == '.png'
    fmt = SpitewasteCLI.validate_format options

    valid_outputs = %i[ws whitespace
                       wsa wsassembly
                       asm assembly
                       cpp codegen]
    if out_fmt = options[:output_format]&.to_sym and !valid_outputs.include?(out_fmt)
      raise ArgumentError, "invalid output format '#{out_fmt}'", []
    end

    ext_map = {
      '.ws'  => :whitespace,
      '.wsa' => :wsassembly,
      '.asm' => :assembly,
      '.cpp' => :codegen}
    out_fmt = Hash[*valid_outputs][out_fmt] || ext_map[ext]
    raise ArgumentError, "can't determine output format", [] unless out_fmt

    opts = options.dup # options is frozen
    if opts[:symbol_file] == '%'
      opts[:symbol_file] = SpitewasteCLI.make_cache_path input
    end

    as = Spitewaste::Assembler.new File.read(input), format: fmt, **opts
    File.open(output, ?w) { |of| as.assemble! format: out_fmt, io: of }
  end
end
