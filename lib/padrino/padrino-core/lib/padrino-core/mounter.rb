module Padrino
  # Represents a particular mounted padrino application
  # Stores the name of the application (app folder name) and url mount path
  # @example MountedApplication.new("blog_app").to("/blog")
  class MountedApplication
    attr_accessor :name, :uri_root, :app_file, :klass
    def initialize(name)
      @name = name
      @klass = name.classify
    end

    # registers the mounted application to Padrino
    def to(mount_url)
      @app_file = Padrino.mounted_root(name, "app.rb")
      @uri_root = mount_url
      Padrino.mounted_apps << self
    end
  end

  class << self
    # Returns the root to the mounted apps base directory
    def mounted_root(*args)
      File.join(Padrino.root, "apps", *args)
    end

    # Returns the mounted padrino applications (MountedApp objects)
    def mounted_apps
      @mounted_apps ||= []
    end

    # Mounts a new sub-application onto Padrino
    # @example Padrino.mount("blog_app").to("/blog")
    def mount(name)
      MountedApplication.new(name)
    end
  end
end
