Blog.controllers :posts do

  get :index, :map => '/' do
    # logger.info "The locale is #{I18n.locale} and the app locale is #{options.locale}!"
    @posts = Post.match_query(params[:query]).page params[:page], :order => [:created_at.desc], :per_page => 5
    render 'posts/index'
  end

  get :show, :map => "/post/:id" do
    @post = Post.from_param(params[:id])
    render 'posts/show'
  end
end