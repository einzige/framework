task :environment do
  Framework::Application.new(ENV['ANALYTICS_ENV'] || 'development').init!
end
