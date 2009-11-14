RACK_ENV = ENV["RACK_ENV"] ||= "development" unless defined? RACK_ENV
require File.dirname(__FILE__) + '/config/boot.rb'

# FileUtils.mkdir_p 'log' unless File.exists?('log')
# log = File.new("log/#{RACK_ENV.downcase}.log", "a")
# $stdout.reopen(log)
# $stderr.reopen(log)

Padrino.mount("app_blog").to("/blog")
Padrino.mount("app_website").to("/website")

Padrino.mounted_apps.each do |app|
  map app.path do
    app.klass.constantize.set :uri_root, app.path
    run app.klass.constantize
  end
end