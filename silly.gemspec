$LOAD_PATH.unshift 'lib'
require 'silly/version'

Gem::Specification.new do |s|
  s.name              = "silly"
  s.version           = Silly::Version
  s.date              = Time.now.strftime('%Y-%m-%d')
  s.license           = "http://www.opensource.org/licenses/MIT"
  s.summary           = 'Silly is a filesystem based Object Document Mapper.'
  s.homepage          = "http://github.com/ruhoh/silly"
  s.email             = "plusjade@gmail.com"
  s.authors           = ['Jade Dominguez']
  s.description       = 'Silly is an ODM for parsing and querying a directory like you would a database -- useful for static websites.'

  s.add_dependency 'mime-types', "~> 2.1"

  s.add_development_dependency 'cucumber', '~> 1'
  s.add_development_dependency 'capybara', '~> 2'
  s.add_development_dependency 'rspec', '~> 2'

  s.files = `git ls-files`.
              split("\n").
              sort.
              reject { |file| file =~ /^(\.|rdoc|pkg|coverage)/ }
end
