require 'spitewaste'
require 'thor'
require 'fileutils'
require 'pathname'

class SpitewasteCLI < Thor
  VALID_FORMATS = %i[spw spitewaste ws whitespace wsa wsassembly asm assembly]
  CACHE_DIR = File.expand_path '~/.cache/spitewaste'

  def self.exit_on_failure?
    exit 1
  end

  # TODO: Figure out how to invoke a command from this class method.
  def self.handle_no_command_error *args
    exec $0, 'exec', *args
  end

  class_option :format,
    desc: 'input format (in case auto-detection misguesses)',
    aliases: '-f'

  class_option :aliases,
    desc: 'augment or override one or more of the default instruction mnemonics [WIP]',
    banner: 'pop:drop...',
    type: :array,
    aliases: '-a'

  class_option :coexist,
    desc: <<DESC,
allow multiple mnemonics to refer to the same instruction where possible [WIP]

\e[1mNOTE: \e[0mIf --no-coexist (the default), aliases take precedence and render the original mnemonics invalid.
DESC
    type: :boolean,
    aliases: '-x'

  def self.validate_format options
    if fmt = options[:format]&.to_sym and !VALID_FORMATS.include?(fmt)
      raise ArgumentError, "invalid format '#{fmt}'", []
    end

    Hash[*VALID_FORMATS][fmt] || fmt # expand short names
  end

  def self.make_cache_path name
    FileUtils.mkpath CACHE_DIR
    base = File.basename File.expand_path(name).tr(?/, ?-), '.*'
    File.join(CACHE_DIR, base[1..]) + '.json'
  end
end
