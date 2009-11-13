require 'sinatra/base'

# Defines our PADRINO_ENV
PADRINO_ENV = ENV["PADRINO_ENV"] ||= ENV["RACK_ENV"] ||= "development"     unless defined? PADRINO_ENV

module Padrino
  
  class PadrinoError; end
  
  class << self
    
    def boot!
      raise PadrinoError, "You must provide a correct PADRINO_ROOT before start" unless defined?(PADRINO_ROOT)
      raise PadrinoError, "You must provide a correct PADRINO_ENV before start"  unless defined?(PADRINO_ENV)
      
      # Attempts to require all dependencies with bundler
      begin
        require 'bundler'
        gemfile_path = root("Gemfile")
        puts ">> Loading GemFile #{gemfile_path}"
        Bundler::Environment.load(gemfile_path).require_env(PADRINO_ENV)
      rescue Bundler::DefaultManifestNotFound => e
        puts ">> You didn't create Bundler Gemfile manifest or you are not in a Sinatra application."
      end
    
      # Attempts to load budled gems if it fail we try to use system wide gems
      begin
        require root('/../vendor', 'gems', PADRINO_ENV)
        puts ">> We use bundled gems"
      rescue LoadError => e
        puts ">> We use system wide gems"
      end
    
      # Attempts to load all necessary dependencies
      load_dependencies("#{root}/lib/**/*.rb", "#{root}/models/*.rb", "#{root}/app_*/models/*.rb")
    end
    
    # Helper method for file references.
    #
    # @param args [Array] Path components relative to ROOT_DIR.
    # @example Referencing a file in config called settings.yml:
    #   Padrino.root("config", "settings.yml")
    def root(*args)
      File.join(PADRINO_ROOT, *args)
    end
    
    # Attempts to load/require all dependency libs that we need.
    # 
    # @param paths [Array] Path where is necessary require or load a dependency
    # @example For load all our app libs we need to do:
    #   load_dependencies("#{Padrino.root}/lib/**/*.rb")
    def load_dependencies(*paths)
      paths.each do |path|
        Dir[path].each { |file| PADRINO_ENV == "production" ? require(file) : load(file) }
      end
    end
  end
  
  class Application < Sinatra::Base
    
    def self.inherited(base)
      
      # Defines basic application settings
      base.set :app_name, base.to_s.underscore
      base.set :app_file, Padrino.root("#{base.app_name}/app.rb")
      base.set :images_path, base.public + "/images"
      base.set :default_builder, 'StandardFormBuilder'
      base.set :environment, PADRINO_ENV
      base.set :logging, true
      base.set :markup, true
      base.set :render, true
      base.set :mailer, true
      
      # We need to load the class
      super
      
      # Required middleware
      base.use Rack::Session::Cookie
      base.use Rack::Flash
      
      # Requires the initializer modules which configure specific components
      Dir[Padrino.root + '/config/initializers/*.rb'].each do |file|
        # Each initializer file contains a module called 'XxxxInitializer' (i.e HassleInitializer)
        require file
        file_class = File.basename(file, '.rb').classify
        base.register "#{file_class}Initializer".constantize
      end
      
      # Includes all necessary sinatra_more helpers
      base.register SinatraMore::MarkupPlugin if base.markup?
      base.register SinatraMore::RenderPlugin if base.render?
      base.register SinatraMore::MailerPlugin if base.mailer?
      
      # Require all helpers
      Dir[base.root + "/helpers/*.rb"].each do |file|
        # Each file contains a module called 'XxxxHelper' (i.e ViewHelper)
        Padrino.load_dependencies(file)
        klass_name = File.basename(file, '.rb').classify
        helpers "#{klass_name}Helper".constantize
      end
      
      # Search our controllers
      Dir[base.root + "/controllers/*.rb"].each do |file|
        # TODO: Better way todo that
        Padrino.load_dependencies(file)
      end
    end
  end
  
end