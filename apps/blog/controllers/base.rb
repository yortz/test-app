Blog::controllers do
  get :index do
    logger.info "This is a test"
    session[:test] = "foo!"
    flash[:notice] = "bar!"
    [
      "Hey! This is the blog!!!!", "", my_helper, Testme.now,
      options.app_name, options.app_file, options.public, options.views, options.images_path,
      url_for(:blog, :index), url_for(:index), User.inspect, session[:test], flash[:notice]
    ].
    join("<br />")
  end
end