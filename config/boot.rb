# This file is merely for beginning the boot process
RACK_ENV = ENV["RACK_ENV"] ||= "development" unless defined? RACK_ENV
ROOT_DIR = File.dirname(__FILE__) + '/..'    unless defined? ROOT_DIR

# Helper method for file references.
#
# @param args [Array] Path components relative to ROOT_DIR.
# @example Referencing a file in config called settings.yml:
#   root_path("config", "settings.yml")
def root_path(*args)
  File.join(ROOT_DIR, *args)
end

# Returns the full path to the public folder along with any given additions
# public_path("images")
def public_path(*args)
  root_path('public', *args)
end

# Attempts to load/require all dependency libs that we need.
# 
# @param paths [Array] Path where is necessary require or load a dependency
# @example For load all our app libs we need to do:
#   load_dependencies("#{root_path}/lib/**/*.rb")
def load_dependencies(*paths)
  paths.each do |path|
    Dir[path].each { |file| RACK_ENV == "production" ? require(file) : load(file) }
  end
end

# Attempts to require all dependencies with bundler
begin
  require 'bundler'
  Bundler::Environment.load(root_path + "/Gemfile").require_env(RACK_ENV)
rescue Bundler::DefaultManifestNotFound => e
  puts "You didn't create Bundler Gemfile manifest or you are not in a Sinatra application."
end

# Attempts to load budled gems if it fail we try to use system wide gems
begin
  require root_path('/../vendor', 'gems', RACK_ENV)
  puts "We use bundled gems"
rescue LoadError => e
  puts "We use system wide gems"
end

# Attempts to load all necessary dependencies
load_dependencies("#{root_path}/lib/**/*.rb", "#{root_path}/models/*.rb", "#{root_path}/app_*/models/*.rb")