Blog.controllers :frontend do
  get :about, :map => '/about' do
    render 'site/about'
  end
end