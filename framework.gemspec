$:.push File.expand_path('../lib', __FILE__)
require 'framework/version'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'framework'
  s.version     = Framework::VERSION
  s.summary     = %q{Ruby Application Framework for all your needs.}
  s.description = %q{Allows to quickly build well structured complex Ruby apps.}

  s.required_ruby_version     = '>= 2.5.0'
  s.required_rubygems_version = '>= 2.5.0'

  s.license = 'MIT'

  s.author   = 'Sergei Nikolaevich Zinin'
  s.email    = 'zinin@xakep.ru'
  s.homepage = 'http://github.com/einzige/framework'

  s.files         = Dir['README.md', 'LICENSE', 'FRAMEWORK_VERSION', 'Rakefile', 'bin/**/*', 'lib/**/*', 'spec/**/*']
  s.test_files    = Dir['spec/**/*']
  s.require_paths = ['lib']

  s.bindir        = 'bin'
  s.executables = ['framework']

  s.add_runtime_dependency 'activerecord',  '~> 6.0.0.rc1'
  s.add_runtime_dependency 'activesupport', '~> 6.0.0.rc1'
  s.add_runtime_dependency 'actionpack',    '~> 6.0.0.rc1'
  s.add_runtime_dependency 'awesome_print', '~> 2.0.0.pre2'
  s.add_runtime_dependency 'rake',          '~> 12.3', '>= 12.3.0'
  s.add_runtime_dependency 'thor',          '~> 0.20', '>= 0.20.3'

  s.add_development_dependency 'bundler', '~> 1.16', '>= 1.16.6'
  s.add_development_dependency 'rspec',   '~> 3.8', '>= 3.8.0'
end

