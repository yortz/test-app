AppBlog::controllers do
  get :index do
    [
      "Hey? This is the blog!!!!", "", my_helper,
      options.app_name, options.app_file, options.public, options.views, options.images_path,
      url_for(:app_blog, :index), url_for(:index)
    ].
    join("<br />")
  end
  
end