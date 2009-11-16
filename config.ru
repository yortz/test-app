RACK_ENV = ENV["RACK_ENV"] ||= "development" unless defined? RACK_ENV
require File.dirname(__FILE__) + '/config/boot.rb'

# FileUtils.mkdir_p 'log' unless File.exists?('log')
# log = File.new("log/#{RACK_ENV.downcase}.log", "a")
# $stdout.reopen(log)
# $stderr.reopen(log)

Padrino.mount("blog").to("/blog")
Padrino.mount("website").to("/website")
run Padrino.application