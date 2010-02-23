Blog.controllers do
  get :about, :map => '/about' do
    render 'site/about'
  end
end