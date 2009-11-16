module Padrino
  # Subclasses of this become independent Padrino applications (stemming from Sinatra::Application)
  # These subclassed applications can be easily mounted into other Padrino applications as well.
  class Application < Sinatra::Application
    
    def logger
      @log_stream ||= self.class.log_to_file? ? Padrino.root("log/#{PADRINO_ENV.downcase}.log") : $stdout
      @logger   ||= Logger.new(@log_stream)
    end

    class << self
      def inherited(base)
        base.default_configuration!
        super # Loading the class
        base.register_initializers
        base.register_framework_extension
        base.require_load_paths
        base.setup_logger
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
        set :logging, true
        set :sessions, true
        set :log_to_file, !development?
        # Padrino specific
        set :app_name, self.to_s.underscore.to_sym
        set :app_file, Padrino.mounted_root(self.app_name.to_s, "/app.rb")
        set :environment, PADRINO_ENV.to_sym
        set :images_path, self.public + "/images"
        set :default_builder, 'StandardFormBuilder'
        enable :flash
        # Plugin specific
        enable :padrino_helpers
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

      # Registers all desired padrino extension helpers/routing
      def register_framework_extension
        register Padrino::Helpers  if padrino_helpers?
        register Padrino::Routing
      end

      # Require all files within the application's load paths
      def require_load_paths
        load_paths.each { |path|  Padrino.load_dependencies(File.join(self.root, path)) }
      end

      # Creates the log directory and redirects output to file if needed
      def setup_logger
        return unless self.log_to_file?
        FileUtils.mkdir_p 'log' unless File.exists?('log')
        log = File.new("log/#{PADRINO_ENV.downcase}.log", "a+")
        $stdout.reopen(log)
        $stderr.reopen(log)
      end

      # Returns the load_paths for the application relative to the application root
      def load_paths
        @load_paths ||= ["models/*.rb", "urls.rb", "controllers/*.rb", "helpers/*.rb"]
      end
    end
  end
end
