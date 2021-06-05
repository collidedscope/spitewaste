require 'spitewaste/version'

class SpitewasteCLI
  desc 'version', 'Display the current version of Spitewaste and exit.'

  def version
    puts "spw version #{Spitewaste::VERSION}"
  end
end
