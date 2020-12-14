class SpitewasteCLI
  desc 'asm INPUT [OUTPUT]',
    'Generate plain Whitespace assembly from INPUT and write it to OUTPUT.'
  long_desc 'Mostly just a convenience wrapper around `spw convert in -o asm out`'

  shared_options

  def asm input, output = '/dev/stdout'
    as = Spitewaste::Assembler.new File.read input
    File.open(output, ?w) { |of| as.assemble! format: :assembly, io: of }
  end
end
