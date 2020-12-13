require_relative 'lib/spitewaste/version'

Gem::Specification.new do |s|
  s.name          = 'spitewaste'
  s.version       = Spitewaste::VERSION
  s.author        = 'Collided Scope (collidedscope)'

  s.summary       = 'Make programming in Whitespace even better.'
  s.description   = 'Spitewaste is a collection of tools that makes it almost too easy to read and write Whitespace programs.'
  s.homepage      = 'https://github.com/collidedscope/spitewaste'
  s.license       = 'WTFPL'

  s.add_dependency 'rake'
  s.add_dependency 'minitest'
  s.add_dependency 'thor'
  s.add_dependency 'oily_png'

  s.files         = `git ls-files`.split.reject { |f| f[/^(test|demo)/] }
  s.bindir        = 'bin'
  s.executables   = ['spw']
  s.require_paths = ['lib']
end
