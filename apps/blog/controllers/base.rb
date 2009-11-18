Blog::controllers do
  get :index do
    logger.info "This is a test"
    session[:test] = "foo!"
    flash[:notice] = "bar!"
    haml_template 'index'
  end
end