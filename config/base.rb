# This file is merely for beginning the boot process, check dependencies.rb for more information
require 'rubygems'
require 'sinatra/base'
require File.dirname(__FILE__) + '/boot'

module Padrino
  
  class Application < Sinatra::Base
    
    def self.inherited(base)
      
      # Defines basic application settings
      base.set :app_name, base.to_s.underscore
      base.set :app_file, root_path("#{base.app_name}/app.rb")
      base.set :images_path, base.public + "/images"
      base.set :default_builder, 'StandardFormBuilder'
      base.set :environment, RACK_ENV
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
      Dir[root_path + '/config/initializers/*.rb'].each do |file|
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