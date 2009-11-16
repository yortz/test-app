module Padrino
  class Application < Sinatra::Base
    class << self
      def inherited(base)
        base.default_configuration!
        super # Loading the class
        base.register_initializers
        base.register_framework
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

      # Defines basic application settings
      def default_configuration!
        set :app_name, self.to_s.underscore.to_sym
        set :app_file, Padrino.root("#{self.app_name}/app.rb")
        set :images_path, self.public + "/images"
        set :default_builder, 'StandardFormBuilder'
        set :environment, PADRINO_ENV
        set :environment, PADRINO_ENV.to_sym
        set :raise_errors, true if development?
        set :logging, true
        set :markup, true
        set :render, true
        set :mailer, true
        set :router, true
      end

      # Requires the middleware and initializer modules which configure specific components
      def register_initializers
        use Rack::Session::Cookie
        use Rack::Flash
        Dir[Padrino.root + '/config/initializers/*.rb'].each do |file|
          Padrino.load_dependencies(file)
          file_class = File.basename(file, '.rb').classify
          register "#{file_class}Initializer".constantize
        end
      end

      # Includes all necessary sinatra_more helpers if required
      def register_framework
        register SinatraMore::MarkupPlugin  if markup?
        register SinatraMore::RenderPlugin  if render?
        register SinatraMore::MailerPlugin  if mailer?
        register SinatraMore::RoutingPlugin if router?
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
