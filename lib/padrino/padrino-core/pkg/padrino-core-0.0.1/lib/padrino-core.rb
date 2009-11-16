require 'sinatra/base'
Dir[File.dirname(__FILE__) + '/padrino-core/**/*.rb'].each {|file| require file }

# Defines our PADRINO_ENV
PADRINO_ENV = ENV["PADRINO_ENV"] ||= ENV["RACK_ENV"] ||= "development" unless defined?(PADRINO_ENV)

module Padrino
  class << self
    # Helper method for file references.
    #
    # @param args [Array] Path components relative to ROOT_DIR.
    # @example Referencing a file in config called settings.yml:
    #   Padrino.root("config", "settings.yml")
    def root(*args)
      File.join(PADRINO_ROOT, *args)
    end

    # Returns the prepared rack application mapping each 'mounted' application
    def application
      Rack::Builder.new do
        Padrino.mounted_apps.each do |app|
          map app.uri_root do
            require app.app_file
            app.klass.constantize.set :uri_root, app.uri_root
            run app.klass.constantize
          end
        end
      end
    end
  end
end