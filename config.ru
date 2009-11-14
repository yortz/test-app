RACK_ENV = ENV["RACK_ENV"] ||= "development" unless defined? RACK_ENV
require File.dirname(__FILE__) + '/config/boot.rb'

# FileUtils.mkdir_p 'log' unless File.exists?('log')
# log = File.new("log/#{RACK_ENV.downcase}.log", "a")
# $stdout.reopen(log)
# $stderr.reopen(log)

# Mounting separate applications
# TODO: requiring shouldnt have to be done manually or assume the application name
Dir[File.dirname(__FILE__) + '/app_*/app.rb'].each do |file| 
  require file
end

Padrino.activate_app("app_blog").to("/blog")
Padrino.activate_app("app_website").to("/website")

Padrino.mounted_apps.each do |app|
  map app.path do
    app.klass.constantize.set :uri_root, app.path
    run app.klass.constantize
  end
end