module Padrino
  class << self
    # Requires necessary dependencies as well as application files from root lib and models
    def load!
      load_required_gems # load bundler gems
      load_dependencies("#{root}/lib/**/*.rb", "#{root}/models/*.rb") # load root app dependencies
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
    
    # Attempts to require all dependencies with bundler; if fails, we try to use system wide gems
    def load_required_gems
      begin
        require 'bundler'
        gemfile_path = root("Gemfile")
        puts ">> Loading GemFile #{gemfile_path}"
        Bundler::Environment.load(gemfile_path).require_env(PADRINO_ENV)
      rescue Bundler::DefaultManifestNotFound => e
        puts ">> You didn't create Bundler Gemfile manifest or you are not in a Sinatra application."
      end

      begin
        require root('/../vendor', 'gems', PADRINO_ENV)
        puts ">> Using bundled gems"
      rescue LoadError => e
        puts ">> Using system wide gems (No bundled gems)"
      end
    end
  end
end