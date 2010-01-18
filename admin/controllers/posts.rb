Admin.controllers :posts do

  get :index, :respond_to => [:js, :json] do
    @store = Post.column_store(options.views, "posts/store")
    case content_type
      when :js    then render 'posts/grid.js'
      when :json  then @store.store_data(params, :links => [Post.relationships[:account].inverse])
    end
  end

  get :new do
    @post = Post.new
    render 'posts/new'
  end

  post :create, :respond_to => :js do
    @post = Post.create(params[:post].merge(:account_id => current_account.id))
    show_messages_for(@post)
  end

  get :edit, :with => :id do
    @post = Post.first(:conditions => { :id => params[:id] })
    render 'posts/edit'
  end

  put :update, :with => :id, :respond_to => :js do
    @post = Post.first(:conditions => { :id => params[:id] })
    @post.update_attributes(params[:post])
    show_messages_for(@post)
  end

  delete :destroy, :respond_to => :json do
    posts  = Post.all(:conditions => { :id => params[:ids].split(",") })
    errors = posts.map { |post| I18n.t("admin.general.cantDelete", :record => post.id) unless post.destroy }.compact
    { :success => errors.empty?, :msg => errors.join("<br />") }.to_json
  end
end