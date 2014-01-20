$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), *%w[lib]))
require 'rubygems'
require 'rake'
require 'bundler'
require 'silly/version'

name = Dir['*.gemspec'].first.split('.').first
gemspec_file = "#{name}.gemspec"
gem_file = "#{name}-#{Silly::VERSION}.gem"

task :release => :build do
  sh "git commit --allow-empty -m 'Release #{Silly::VERSION}'"
  sh "git tag v#{Silly::VERSION}"
  sh "git push origin master --tags"
  sh "git push origin v#{Silly::VERSION}"
  sh "gem push pkg/#{name}-#{Silly::VERSION}.gem"
end

task :build do
  sh "mkdir -p pkg"
  sh "gem build #{gemspec_file}"
  sh "mv #{gem_file} pkg"
end