Admin.controllers :comments do

  get :index, :respond_to => [:js, :json] do
    @store = Comment.column_store(options.views, "comments/store")
    case content_type
      when :js    then render 'comments/grid.js'
      when :json  then @store.store_data(params)
    end
  end

  get :new do
    @comment = Comment.new
    render 'comments/new'
  end

  post :create, :respond_to => :js do
    @comment = Comment.create(params[:comment])
    show_messages_for(@comment)
  end

  get :edit, :with => :id do
    @comment = Comment.first(:conditions => { :id => params[:id] })
    render 'comments/edit'
  end

  put :update, :with => :id, :respond_to => :js do
    @comment = Comment.first(:conditions => { :id => params[:id] })
    @comment.update_attributes(params[:comment])
    show_messages_for(@comment)
  end

  delete :destroy, :respond_to => :json do
    comments = Comment.all(:conditions => { :id => params[:ids].split(",") })
    errors = comments.map { |comment| I18n.t("admin.general.cantDelete", :record => comment.id) unless comment.destroy }.compact
    { :success => errors.empty?, :msg => errors.join("<br />") }.to_json
  end
end