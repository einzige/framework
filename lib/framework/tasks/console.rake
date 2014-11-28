desc "Runs irb console and initializes the application"
task :console, :env do |_, args|
  require 'irb'

  unless env = ENV['ANALYTICS_ENV']
    env = args[:env] || Framework::DEFAULT_ENV
  end

  system "mkdir -p #{Dir.pwd}/db/#{env}"

  Framework::Application.new(env) do |app|
    app.init!
    app.hint("Use `Framework.app` variable to deal with application API")

    require "awesome_print"
    AwesomePrint.irb!
  end

  ARGV.clear
  IRB.start
end
