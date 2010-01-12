Blog.controllers :comments do  
  post :create, :with => :post_id, :respond_to => :js do
    @post = Post.from_param(params[:post_id])
    @comment = @post.comments.create(params[:comment])
    render 'comments/create.js'
  end
end