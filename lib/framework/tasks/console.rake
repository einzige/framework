desc 'Runs irb console and initializes the application'
task :console, :env do |_, args|
  env = ENV['FRAMEWORK_ENV'] ||= args[:env] || ENV['RAILS_ENV']
  system "mkdir -p #{Dir.pwd}/db/#{env}"

  require 'irb'
  require File.expand_path('config/environment')
  require 'awesome_print'

  AwesomePrint.irb!
  ARGV.clear
  IRB.start
end
