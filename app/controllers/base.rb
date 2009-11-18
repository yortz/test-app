Website::controllers do
  get :index do
    session[:test] = "foobar"
    haml_template 'index'
  end

  get :test do
    haml_template 'test'
  end
end