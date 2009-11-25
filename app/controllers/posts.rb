# Define your named routes inside config/urls.rb or define them inline
# You can also use unnamed routes by defining them directly

Blog.controllers :posts do  
  get :index, :map => '/' do
    logger.info "Beautiful log!"
    @posts = Post.match_query(params[:query]).page params[:page], :order => [:created_at.desc], :per_page => 5
    haml_template 'posts/index'
  end
  
  get :new, :map => '/posts/new' do
    @post = Post.new
    haml_template 'posts/new'
  end
  
  post :create, :map => '/posts' do
    @post = Post.new(params[:post])
    if @post.save
      redirect url_for(:posts, :index)
    else
      haml_template 'posts/new'
    end
  end
  
  get :show, :map => '/post/:id' do
    @post = Post.from_param(params[:id])
    haml_template 'posts/show'
  end
  
  delete :destroy, :map => '/post/:id' do
    @post = Post.from_param(params[:id])
  end
end