require_relative 'lib/spitewaste/version'

Gem::Specification.new do |s|
  s.name          = 'spitewaste'
  s.version       = Spitewaste::VERSION
  s.author        = 'Collided Scope (collidedscope)'

  s.summary       = 'Make programming in Whitespace even better.'
  s.description   = 'Spitewaste is a collection of tools that makes it almost too easy to read and write Whitespace programs.'
  s.homepage      = 'https://github.com/collidedscope/spitewaste'
  s.license       = 'WTFPL'

  s.add_dependency 'rake', '~> 13.0.1'
  s.add_dependency 'minitest', '~> 5.14.2'
  s.add_dependency 'thor', '~> 1.0.1'
  s.add_dependency 'oily_png', '~> 1.2.1'

  s.files         = `git ls-files`.split.reject { |f| f[/^(test|demo)/] }
  s.bindir        = 'bin'
  s.executables   = ['spw']
  s.require_paths = ['lib']
end
