class Blog < Padrino::Application
  configure do
    # set :log_to_file, true # Enable to log to file instead of stdout
  end
  
  get "/wine" do
    "wine"
  end
  
  get :tester, :map => '/test' do
    "This raises a large error"
  end
end
