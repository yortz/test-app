Blog::controllers do
  get :index do
    session[:test] = "foobar"
    flash[:notice] = "tester"
    [
      "Hey? This is the blog!!!!", "", my_helper,
      options.app_name, options.app_file, options.public, options.views, options.images_path,
      url_for(:blog, :index), url_for(:index), User.inspect, session[:test], flash[:notice]
    ].
    join("<br />")
  end
end