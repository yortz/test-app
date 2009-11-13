RACK_ENV = ENV["RACK_ENV"] ||= "development" unless defined? RACK_ENV
require File.dirname(__FILE__) + '/config/base.rb'

# FileUtils.mkdir_p 'log' unless File.exists?('log')
# log = File.new("log/#{RACK_ENV.downcase}.log", "a")
# $stdout.reopen(log)
# $stderr.reopen(log)

Dir[File.dirname(__FILE__) + '/app_*/app.rb'].each do |file| 
  require file
  klass_name = File.basename(File.dirname(file)).gsub(/app_/, "")
  klass      = "App#{klass_name.classify}".constantize
  puts ">> Loading App #{klass_name} on: /#{klass_name}"
  map "/#{klass_name}" do
    run klass
  end
end