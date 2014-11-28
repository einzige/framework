# encoding: utf-8
$:.unshift(File.expand_path("../../", __FILE__))
ENV['BUNDLE_GEMFILE'] = 'Gemfile'

require 'framework'
require 'rubygems'
require 'bundler'
require 'rake'
require 'rake/testtask'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

Dir["#{File.expand_path("../", __FILE__)}/tasks/engine/*.rake"].each(&method(:load))
Dir["#{File.expand_path("../", __FILE__)}/tasks/*.rake"].each(&method(:load))
