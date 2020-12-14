require 'open3'
require 'stringio'

class SpitewasteCLI
  desc 'compile [OPTIONS] FILE',
    'Compile a Whitespace program to native machine instructions.'

  long_desc <<-DESC
Under the hood, this command simply converts the input program's Whitespace
instructions to functionally equivalent C++ code and lets a modern compiler
do all the heavy lifting. The results are still quite good, but you'll need
a compiler and libgmpxx (arbitrary precision) for this to do the right thing.
DESC

  option :compiler,
    banner: 'PROG',
    desc: 'a C++ compiler',
    default: 'c++',
    aliases: '-c'

  option :output,
    banner: 'FILE',
    desc: 'the name of the executable to produce
(defaults to input without extension, or a.out if input is from stdin)',
    aliases: '-o'

  option :argv,
    desc: 'additional flags to provide to the C++ compiler',
    default: '-O3 -lgmp -lgmpxx',
    aliases: '-v'

  option :run,
    desc: 'immediately invoke the resultant executable, then remove it',
    type: :boolean,
    aliases: '-r'

  option :keep,
    desc: "with --run, don't remove the executable",
    type: :boolean,
    aliases: '-k'

  shared_options

  def compile file = nil
    fmt = SpitewasteCLI.validate_format options

    out = options[:output]
    out ||= file ? File.basename(file, '.*') : 'a.out'
    file ||= '/dev/stdin'

    as = Spitewaste::Assembler.new File.read(file), format: fmt
    as.assemble! format: :codegen, io: cpp = StringIO.new

    cmd = "#{options[:compiler]} -x c++ -o #{out} #{options[:argv]} -"
    Open3.capture2 cmd, stdin_data: cpp.string

    if options[:run]
      print `./#{out}`
      File.delete out unless options[:keep]
    end
  end
end
