module Padrino
  # Subclasses of this become independent Padrino applications (stemming from Sinatra::Application)
  # These subclassed applications can be easily mounted into other Padrino applications as well.
  class Application < Sinatra::Application
    class << self
      def inherited(base)
        base.default_configuration!
        super # Loading the class
        base.register_initializers
        base.register_framework_plugins
        base.require_load_paths
      end

      # Makes the routes defined in the block and in the Modules given
      # in `extensions` available to the application
      def controllers(*extensions, &block)
        instance_eval(&block) if block_given?
        include(*extensions) if extensions.any?
      end

      # Makes the urls defined in the block and in the Modules given
      # in `extensions` available to the application
      def urls(*extensions, &block)
        instance_eval(&block) if block_given?
        include(*extensions) if extensions.any?
      end
      
      protected

      # Defines default settings for Padrino application
      def default_configuration!
        # Overwriting Sinatra defaults
        set :raise_errors, true if development?
        set :sessions, true
        set :logging, true
        # Padrino specific
        set :app_name, self.to_s.underscore.to_sym
        set :app_file, Padrino.root("#{self.app_name}/app.rb")
        set :environment, PADRINO_ENV.to_sym
        set :images_path, self.public + "/images"
        set :default_builder, 'StandardFormBuilder'
        set :flash, true
        # Plugin specific
        enable :markup_plugin
        enable :render_plugin
        enable :mailer_plugin
        enable :router_plugin
      end

      # Requires the middleware and initializer modules to configure components
      def register_initializers
        use Rack::Session::Cookie
        use Rack::Flash if flash?
        Dir[Padrino.root + '/config/initializers/*.rb'].each do |file|
          Padrino.load_dependencies(file)
          file_class = File.basename(file, '.rb').classify
          register "#{file_class}Initializer".constantize
        end
      end

      # Registers all desired sinatra_more helpers
      def register_framework_plugins
        register SinatraMore::MarkupPlugin  if markup_plugin?
        register SinatraMore::RenderPlugin  if render_plugin?
        register SinatraMore::MailerPlugin  if mailer_plugin?
        register SinatraMore::RoutingPlugin if router_plugin?
      end

      # Returns the load_paths for the application relative to the application root
      def load_paths
        @load_paths ||= ["models/*.rb", "urls.rb", "controllers/*.rb", "helpers/*.rb"]
      end

      # Require all files within the application's load paths
      def require_load_paths
        load_paths.each { |path|  Padrino.load_dependencies(File.join(self.root, path)) }
      end
    end
  end
end
