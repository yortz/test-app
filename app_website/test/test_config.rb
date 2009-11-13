RACK_ENV = 'test' unless defined?(RACK_ENV)
%w[rubygems sinatra/base].each {|gem| require gem }
require 'bacon'
require 'rack/test'
require 'mocha'
require File.dirname(__FILE__) + "/../app"

class Bacon::Context
  include Mocha::API
  include Rack::Test::Methods
end

def app
  Example.tap { |app| app.set :environment, :test }
end
