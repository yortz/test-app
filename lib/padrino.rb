require 'sinatra/base'

# Defines our PADRINO_ENV
PADRINO_ENV = ENV["PADRINO_ENV"] ||= ENV["RACK_ENV"] ||= "development" unless defined?(PADRINO_ENV)

module Padrino
  
  class << self
    
    def mounted_apps
      @mounted_apps ||= []
    end
    
    def mount(name)
      require File.join(root, name, "app.rb")
      MountedApp.new(name)
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
        Dir[path].each { |file| require(file) }
      end
    end
  end
  
  class MountedApp
    attr_accessor :name, :path, :klass
    def initialize(name)
      @name = name
      @klass = name.classify
    end
    
    def to(mount_url)
      @path = mount_url
      Padrino.mounted_apps << self
    end
  end
    
  
  # Padrino delegator is a class usefull for delegate certain methods to another class
  # 
  # Usually we delegate :get, :post, :delete, :put etc from Controllers to their Sinatra Application
  # We can delegate also for example route mapping methods (:map) from i.e. Urls to their Sinatra Application
  # 
  class Delegator
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
  
  class Application < Sinatra::Base
    
    class Controllers < Delegator; end
    class Urls < Delegator; end

    class << self
      
      def controllers(*extensions, &block)
        @controllers.instance_eval(&block)       if block_given?
        @controllers.send(:include, *extensions) if extensions.any?
      end
      
      def urls(*extensions, &block)
        @urls.instance_eval(&block)       if block_given?
        @urls.send(:include, *extensions) if extensions.any?
      end
      
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
        
        base.configure :development do
          base.set :raise_errors, true
        end
        
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

        base.instance_variable_set(:@controllers, Controllers.new)
        base.instance_variable_set(:@urls, Urls.new)
        
        [ # We delegate certain methods to our controller
         :get, :put, :post, :delete, :head, :template, :layout,
         :before, :after, :error, :not_found, :mime_type, :map,
         :development?, :test?, :production?, :use_in_file_templates!, :helpers
        ].each { |method_name| base.instance_variable_get(:@controllers).delegate(method_name).to(base) }
        
        base.instance_variable_get(:@urls).delegate(:map).to(base)
        
        # Search our urls
        Padrino.load_dependencies(base.root + "/urls.rb")
        
        # Search our controllers
        Dir[base.root + "/controllers/*.rb"].each do |file|
          Padrino.load_dependencies(file)
        end
        
        # Search our helpers
        Dir[base.root + "/helpers/*.rb"].each do |file|
          Padrino.load_dependencies(file)
        end
      end
    end
  end
  
end