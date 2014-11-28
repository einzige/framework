require 'thor'

require 'framework'
require 'framework/generators/multi_generator'
require 'framework/generators/application_generator'

module Framework
  class Cli < Thor
    register(Framework::ApplicationGenerator, 'new', 'new APP_NAME', 'Generates new application')
    register(Framework::MultiGenerator, 'generate', 'generate <migration>', 'Generates the thing you want')
  end
end
