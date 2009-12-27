# Define your named routes inside config/urls.rb or define them inline
# You can also use unnamed routes by defining them directly

Blog.controllers :frontend, :posts do
  
  get :index, :map => '/' do
    logger.info "The locale is #{I18n.locale} and the app locale is #{options.locale}"
    @posts = Post.match_query(params[:query]).page params[:page], :order => [:created_at.desc], :per_page => 5
    render 'posts/index'
  end
  
  get :new, :map => '/posts/new' do
    @post = Post.new
    render 'posts/new'
  end
  
  post :create, :map => '/posts' do
    @post = Post.new(params[:post])
    if @post.save
      redirect url_for(:frontend, :posts, :index)
    else
      render 'posts/new'
    end
  end
  
  get :show, :map => '/post/:id' do
    @post = Post.from_param(params[:id])
    render 'posts/show'
  end
  
  delete :destroy, :map => '/post/:id' do
    @post = Post.from_param(params[:id])
  end
end