class Admin < Padrino::Application
  configure do
    # Application-specific configuration options
    # set :sessions, false     # Enabled by default
    # set :log_to_file, true   # Log to file instead of stdout (default is stdout in development)
    # set :reload, false       # Reload application files (default in development)
    # disable :padrino_helpers # Disables padrino markup helpers (enabled by default)
    # disable :flash           # Disables rack-flash (enabled by default)
    layout false
    enable :authentication
    set :use_orm, :data_mapper
    access_control.roles_for :any do |role|
      role.allow ""
    end
  end
end