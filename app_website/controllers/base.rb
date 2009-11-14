AppWebsite::controllers do
  
  map(:index).to("")
  map(:test).to("/test")
  
  get :index do
    [
      "Hey? This is the website!!!!", "",
      options.app_name, options.app_file, options.public, options.views, options.images_path,
      url_for(:app_website, :test), url_for(:test)
    ].
    join("<br />")
  end
  
  get :test do
    "Ya ya, you found me only on website"
  end
  
end