Blog.controllers :demo do
  get :index do
    logger.info "This is a test"
    session[:test] = "foo!"
    flash[:notice] = "bar!"
    haml_template 'index'
  end
  
  get :other, :map => "/other/:id" do
    "hello world with id #{params[:id]}" + "<br/>url: " + url_for(:demo, :other, :id => 5)
  end
end