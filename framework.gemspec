$:.push File.expand_path('../lib', __FILE__)
require 'framework/version'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'framework'
  s.version     = Framework::VERSION
  s.summary     = %q{Ruby Application Framework for all your needs.}
  s.description = %q{Allows to quickly build well structured complex Ruby apps.}

  s.required_ruby_version     = '>= 3.2.1'
  s.required_rubygems_version = '>= 3.2.1'

  s.license = 'MIT'

  s.author   = 'Sergei Nikolaevich Zinin'
  s.email    = 'zinin@xakep.ru'
  s.homepage = 'http://github.com/einzige/framework'

  s.files         = Dir['README.md', 'LICENSE', 'FRAMEWORK_VERSION', 'Rakefile', 'bin/**/*', 'lib/**/*', 'spec/**/*']
  s.test_files    = Dir['spec/**/*']
  s.require_paths = ['lib']

  s.bindir        = 'bin'
  s.executables = ['framework']

  s.add_runtime_dependency 'activerecord',  '~> 7.0.4'
  s.add_runtime_dependency 'activesupport', '~> 7.0.4'
  s.add_runtime_dependency 'actionpack',    '~> 7.0.4'
  s.add_runtime_dependency 'rake',          '~> 13.0', '>= 13.0.6'
  s.add_runtime_dependency 'thor',          '~> 1.2', '>= 1.2.1'

  s.add_development_dependency 'bundler', '~> 2.4', '>= 2.4'
  s.add_development_dependency 'rspec',   '~> 3.12', '>= 3.12.0'
end

