Admin.controllers :sessions do
  
  get :new, :map => "/" do
    render "/sessions/new"
  end
  
  post :create do
    redirect url_for(:sessions, :new)
  end
  
  delete :destroy do
    render "/sessions/new"
  end
end