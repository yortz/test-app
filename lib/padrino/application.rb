require 'padrino/delegator'

module Padrino
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

      def load_paths
        @load_paths ||= ["models/*.rb", "urls.rb", "controllers/*.rb", "helpers/*.rb"]
      end

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

      def register_framework
        # Includes all necessary sinatra_more helpers if required
        register SinatraMore::MarkupPlugin  if markup?
        register SinatraMore::RenderPlugin  if render?
        register SinatraMore::MailerPlugin  if mailer?
        register SinatraMore::RoutingPlugin if router?
      end

      def require_application_files
        instance_variable_set(:@controllers, Controllers.new)
        instance_variable_set(:@urls, Urls.new)
        [ # We delegate certain methods to our controller
          :get, :put, :post, :delete, :head, :template, :layout,
          :before, :after, :error, :not_found, :mime_type, :map,
          :development?, :test?, :production?, :use_in_file_templates!, :helpers
          ].each { |method_name| instance_variable_get(:@controllers).delegate(method_name).to(self) }
        instance_variable_get(:@urls).delegate(:map).to(self)
        load_paths.each { |path|  Padrino.load_dependencies(File.join(self.root, path)) }
      end

      def inherited(base)
        base.default_configuration!
        super # Loading the class
        base.register_initializers
        base.register_framework
        base.require_application_files
      end
    end
  end
end
