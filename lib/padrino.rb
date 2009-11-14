require 'sinatra/base'

# Defines our PADRINO_ENV
PADRINO_ENV = ENV["PADRINO_ENV"] ||= ENV["RACK_ENV"] ||= "development" unless defined?(PADRINO_ENV)

module Padrino  
  class << self
    
    def mounted_apps
      (@mounted_apps ||= [])
    end
    
    def activate_app(name)
      MountedApp.new(self, name)
    end
    
    def boot!
      
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
        puts ">> No bundled gems, using system wide gems..."
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
  
  class MountedApp
    attr_accessor :name, :path, :klass
    def initialize(parent, name)
      @parent = parent
      @name = name
      @klass = name.classify
    end
    
    def to(mount_url)
      @path = mount_url
      @parent.mounted_apps << self
    end
  end
  
  # Padrino delegator is a class usefull for delegate certain methods to another class
  # 
  # Usually we delegate :get, :post, :delete, :put etc from RouteController to their Sinatra Application
  # We can delegate also for example route mapping methods (:map) from i.e. Padrino::Routing to their Sinatra Application
  # 
  class Delegator
    class << self
      def inherited(base)
        @base = base
      end

      def delegate(method_name)
        @method_name = method_name
        self
      end
    
      def to(klass)
        (class << self; self; end).class_eval <<-RUBY
          def #{@method_name}(*args, &b); #{klass}.send(#{@method_name.inspect}, *args, &b); end
          private #{@method_name.inspect}
        RUBY
      end
    end
  end
  
  class Application < Sinatra::Base
    
    class << self
      def inherited(base)
        # Defines basic application settings
        base.set :app_name, base.to_s.underscore.to_sym
        base.set :app_file, Padrino.root("#{base.app_name}/app.rb")
        base.set :images_path, base.public + "/images"
        base.set :default_builder, 'StandardFormBuilder'
        base.set :environment, PADRINO_ENV
        base.set :logging, true
        base.set :markup, true
        base.set :render, true
        base.set :mailer, true
        base.set :router, true
        
        # We need to load the class
        super
        
        # Required middleware
        base.use Rack::Session::Cookie
        base.use Rack::Flash
        
        # Requires the initializer modules which configure specific components
        Dir[Padrino.root + '/config/initializers/*.rb'].each do |file|
          Padrino.load_dependencies(file)
          file_class = File.basename(file, '.rb').classify
          base.register "#{file_class}Initializer".constantize
        end
        
        # Includes all necessary sinatra_more helpers if required
        base.register SinatraMore::MarkupPlugin  if base.markup?
        base.register SinatraMore::RenderPlugin  if base.render?
        base.register SinatraMore::MailerPlugin  if base.mailer?
        base.register SinatraMore::RoutingPlugin if base.router?
        
        # Require all helpers
        Dir[base.root + "/helpers/*.rb"].each do |file|
          Padrino.load_dependencies(file)
          klass_name = File.basename(file, '.rb').classify
          helpers "#{klass_name}Helper".constantize
        end
        
        # We build for base their RouteController
        base.class_eval("class ::Padrino::RouteController < Delegator; end")
        
        [ # We delegate certain methods to our controller
         :get, :put, :post, :delete, :head, :template, :layout,
         :before, :after, :error, :not_found, :mime_type, :map,
         :development?, :test?, :production?, :use_in_file_templates!, :helpers
        ].each { |method_name| RouteController.delegate(method_name).to(base) }
        
        # Search our controllers
        Dir[base.root + "/controllers/*.rb"].each do |file|
          Padrino.load_dependencies(file)
        end
      end
    end
  end
  
end