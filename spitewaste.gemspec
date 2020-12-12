require_relative 'lib/spitewaste/version'

Gem::Specification.new do |spec|
  spec.name          = 'spitewaste'
  spec.version       = Spitewaste::VERSION
  spec.author        = 'Collided Scope (collidedscope)'

  spec.summary       = 'Make programming in Whitespace even better.'
  spec.description   = 'Spitewaste is a collection of tools that makes it almost too easy to write Whitespace.'
  spec.homepage      = 'https://github.com/collidedscope/spitewaste'
  spec.license       = 'WTFPL'

  spec.files         = `git ls-files`.split.reject { |f| f[/^test/] }
  spec.bindir        = 'bin'
  spec.executables   = ['spw']
  spec.require_paths = ['lib']
end
