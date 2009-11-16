RACK_ENV = ENV["RACK_ENV"] ||= "development" unless defined? RACK_ENV
require File.dirname(__FILE__) + '/config/boot.rb'

Padrino.mount("blog").to("/blog")
Padrino.mount("website").to("/website")

run Padrino.application