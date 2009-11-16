module Padrino
  # Represents a particular mounted padrino application
  # Stores the name of the application (app folder name) and url mount path
  # @example MountedApplication.new("blog_app").to("/blog")
  class MountedApplication
    attr_accessor :name, :path, :klass
    def initialize(name)
      @name = name
      @klass = name.classify
    end

    # registers the mounted application to Padrino
    def to(mount_url)
      @path = mount_url
      Padrino.mounted_apps << self
    end
  end

  class << self
    # Returns the mounted padrino applications (MountedApp objects)
    def mounted_apps
      @mounted_apps ||= []
    end

    # Mounts a new sub-application onto Padrino
    # @example Padrino.mount("blog_app").to("/blog")
    def mount(name)
      require File.join(root, name, "app.rb")
      MountedApplication.new(name)
    end
  end
end