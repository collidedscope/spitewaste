class SpitewasteCLI
  desc 'image [OPTIONS] INPUT OUTPUT', <<DESC
Generate a PNG file of syntax-highlighted Whitespace.

TODO:
more desc here
DESC

  option :colors,
    banner: 'scheme|FILE',
    desc: 'colors to use to highlight instructions "semantically"',
    aliases: '-c'

  option :tab_width,
    banner: 'SPACES',
    desc: 'number of spaces that tabs should be displayed as (default: 4)',
    type: :numeric,
    aliases: '-t'

  option :margin,
    banner: 'PIXELS',
    desc: 'amount of whitespace (😉) around the edge of the program (default: 20)',
    type: :numeric,
    aliases: '-m'

  option :padding,
    banner: 'PIXELS',
    desc: 'amount of padding between individual elements of syntax (default: 1)',
    type: :numeric,
    aliases: '-p'

  option :cell_size,
    banner: 'PIXELS',
    desc: 'height of individual cells; width will be half of this value (default: 24)',
    type: :numeric,
    aliases: '-s'

  option :line_height,
    banner: 'PIXELS',
    desc: 'height of individual lines to influence vertical spacing (default: 28)',
    type: :numeric,
    aliases: '-l'

  def image input, output = nil
    fmt = SpitewasteCLI.validate_format options
    output ||= Pathname.new(input).sub_ext '.png'

    as = Spitewaste::Assembler.new File.read(input), format: fmt
    File.open(output, ?w) { |of|
      as.assemble! format: :image, io: of, **options.transform_keys(&:to_sym)
    }
  end
end
