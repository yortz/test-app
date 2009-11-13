# This file is merely for beginning the boot process, check dependencies.rb for more information
require 'rubygems'
require 'sinatra/base'
require File.dirname(__FILE__) + '/boot'

module DeanMartin
  
  class Application < Sinatra::Base
    
    # Defines basic application settings
    set :app_file, Proc.new { root_path("#{app_name}/app.rb") }
    set :images_path, Proc.new { public + "/images" }
    set :default_builder, 'StandardFormBuilder'
    set :environment, RACK_ENV if defined?(RACK_ENV)
    set :logging, true
    
    def self.inherited(base)
      
      # We need to set the app_name
      base.set :app_name, base.to_s.underscore
      
      # We need to load the class
      super
      
      # Required middleware
      base.use Rack::Session::Cookie
      base.use Rack::Flash
      
      # Requires the initializer modules which configure specific components
      Dir[root_path + '/config/initializers/*.rb'].each do |file|
        # Each initializer file contains a module called 'XxxxInitializer' (i.e HassleInitializer)
        require file
        file_class = File.basename(file, '.rb').classify
        base.register "#{file_class}Initializer".constantize
      end
      
      # Includes all necessary sinatra_more helpers
      base.register SinatraMore::MarkupPlugin
      base.register SinatraMore::RenderPlugin
      base.register SinatraMore::MailerPlugin
      base.register SinatraMore::WardenPlugin
      
      # Require all helpers
      Dir[base.root + "/helpers/*.rb"].each do |file|
        # Each file contains a module called 'XxxxHelper' (i.e ViewHelper)
        load_dependencies(file)
        klass_name = File.basename(file, '.rb').classify
        helpers "#{klass_name}Helper".constantize
      end
      
      # Search our controllers
      Dir[base.root + "/controllers/*.rb"].each do |file|
        # TODO: Better way todo that
        load_dependencies(file)
      end
    end
  end
end