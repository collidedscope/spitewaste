require 'oily_png'
require 'stringio'
require 'yaml'

module Spitewaste
  class ImageEmitter < Emitter
    SCHEMES  = YAML.load_file(File.join __dir__, 'schemes.yaml')['schemes']
    LINEFEED = ChunkyPNG::Image.from_file File.join __dir__, 'linefeed.png'
    DEFAULTS =  {
      colors: 'gruvbox_dark',
      tab_width: 4, padding: 1, margin: 20,
      cell_size: 24, line_height: 28
    }

    def emit io:
      io.write generate_image
    end

    private

    def generate_image
      @options = DEFAULTS.merge options
      line, padding, margin = @options.values_at :line_height, :padding, :margin
      height = @options[:cell_size]
      width  = height / 2

      img, rects = generate_rects
      linefeeds = @palette[:bright].values.map { |c|
        lf = LINEFEED # no need to dup; modify in-place then store resampled
        lf.pixels.map! { |p| p == 0 ? 0 : c }
        [c, lf.resample_bilinear(height, height / 2)]
      }.to_h

      rects.each do |x, y, x2, color|
        if x2 # space or tab
          img.rect x * width + margin,
            y * line + margin,
            x2 * width + margin - padding - 1,
            y * line + height + margin - padding - 1,
            color, color
        else # draw fancy linefeed
          img.compose! linefeeds[color],
            x * width + margin + padding,
            y * line + margin + height / 4
        end
      end

      img
    end

    def generate_rects
      # We need two representations of the program:
      #  - stream of ops/args to determine how to emit (colors, etc.)
      #  - Whitespace tokens (what to emit)
      # We know `instructions` to be a valid instance of the first, so we just
      # convert those to get the second rather than doing another parse + emit.
      stream = instructions.flatten.compact
      chunks = stream.map { |token|
        OPERATORS_M2T[token] || WhitespaceEmitter.encode(token)
      }

      # Determine the size of the output image.
      tw     = @options[:tab_width]
      lines  = chunks.join.lines
      rows   = lines.size
      cols   = lines.map { |line|
        line.size + tw.pred * line.count(?\t) + line.count(?\n)
      }.max
      width  = cols * @options[:cell_size] / 2 + @options[:margin] * 2
      height = rows * @options[:line_height]   + @options[:margin] * 2

      # Map palette colors to 32-bit values for ChunkyPNG.
      @palette = generate_palette.transform_keys &:to_sym
      %i[normal bright].each { |style|
        @palette[style].transform_values!(&ImageEmitter.method(:parse_color))
      }

      img = ChunkyPNG::Image.new width, height, @palette[:primary]['background']
      x = y = 0

      rects = chunks.zip(stream).flat_map { |tokens, type|
        tokens.chars.map { |token|
          cx, cy = x, y
          nx = case token
               when ' ' ; x += 1 ; cx + 1
               when ?\t ; x += tw ; cx + tw
               when ?\n ; x, y = 0, y + 1 ; nil
               end
          [cx, cy, nx, color_for(token, type)]
        }
      }

      [img, rects]
    end

    def generate_palette
      scheme = @options[:colors]
      palette = SCHEMES[scheme]
      palette ||= if File.exists?(scheme)
                    YAML.load_file(scheme)['colors']
                  else
                    warn "can't load colorscheme #{scheme}; " +
                      "falling back to gruvbox_dark"
                    SCHEMES['gruvbox_dark']
                  end
      {stack: 'blue', flow: 'red', math: 'green', heap: 'yellow',
       io: 'yellow', calls: 'cyan', number: 'magenta'}.merge palette
    end

    INSN_GROUPS = {
      stack: %i[push pop dup swap copy slide],
      flow:  %i[jump jz jn ret exit],
      math:  %i[add sub mul div mod],
      heap:  %i[store load],
      io:    %i[ichr inum ochr onum shell],
      calls: %i[call label]
    }.flat_map { |type, insns| insns.map { |i| [i, type] } }.to_h

    def color_for token, type
      colors = @palette[token == ?\t ? :normal : :bright]
      type = :number if type.is_a? Integer
      type = INSN_GROUPS[type] unless @palette[type]
      colors[@palette[type]]
    end

    def self.parse_color color
      case color
      when Integer
        color << 8 | 255
      else
        Integer(color) << 8 | 255
      end
    end
  end
end
