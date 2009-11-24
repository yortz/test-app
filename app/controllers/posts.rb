# Define your named routes inside config/urls.rb or define them inline
# You can also use unnamed routes by defining them directly

Blog.controllers :posts do
  get :index, :map => '/' do
    @posts = Post.all
    haml_template 'posts/index'
  end
end