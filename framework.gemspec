$:.push File.expand_path('../lib', __FILE__)
require 'framework/version'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'framework'
  s.version     = Framework::VERSION
  s.summary     = %q{Ruby Application Framework for all your needs.}
  s.description = %q{Allows to quickly build well structured complex Ruby apps.}

  s.required_ruby_version     = '>= 2.0.0'
  s.required_rubygems_version = '>= 2.2.2'

  s.license = 'MIT'

  s.author   = 'Sergei Nikolaevich Zinin'
  s.email    = 'zinin@xakep.ru'
  s.homepage = 'http://github.com/einzige/framework'

  s.files         = Dir['README.md', 'LICENSE', 'FRAMEWORK_VERSION', 'Rakefile', 'bin/**/*', 'lib/**/*', 'spec/**/*']
  s.test_files    = Dir['spec/**/*']
  s.require_paths = ['lib']

  s.bindir        = 'bin'
  s.executables = ['framework']

  s.add_runtime_dependency 'activerecord',  '~> 4.0',  '>= 4.0.0'
  s.add_runtime_dependency 'activesupport', '~> 4.0',  '>= 4.0.0'
  s.add_runtime_dependency 'awesome_print', '~> 1.2',  '>= 1.2.0'
  s.add_runtime_dependency 'rake',          '~> 10.3', '>= 10.3.2'
  s.add_runtime_dependency 'thor',          '~> 0.19', '>= 0.19.1'

  s.add_development_dependency 'bundler', '~> 1.6', '>= 1.6.2'
  s.add_development_dependency 'rspec',   '~> 3.1', '>= 3.1.0'
end

