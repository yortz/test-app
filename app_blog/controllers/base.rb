class BaseRoutes < Padrino::RouteController

  get "" do
    [
      "Hey? This is the blog!!!!", "",
      options.app_name, options.app_file, options.public, options.views, options.images_path
    ].
    join("<br />")
  end
  
end