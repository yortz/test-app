class Admin < Padrino::Application
  configure do
    # Application-specific configuration options
    # set :sessions, false     # Enabled by default
    # set :log_to_file, true   # Log to file instead of stdout (default is stdout in development)
    # set :reload, false       # Reload application files (default in development)
    # disable :padrino_helpers # Disables padrino markup helpers (enabled by default)
    # disable :flash           # Disables rack-flash (enabled by default)
    layout false
    enable  :authentication
    disable :store_location
    set :use_orm, :datamapper
    set :login_page, "/admin/sessions/new"

    access_control.roles_for :any do |role|
      role.allow "/sessions"
    end

    access_control.roles_for :admin do |role, account|
      role.allow "/"

      role.project_module :accounts do |project|
        project.menu :list, "/admin/accounts.js"
        project.menu :new,  "/admin/accounts/new"
      end

      role.project_module :posts do |project|
        project.menu :list, "/admin/posts.js"
        project.menu :new,  "/admin/posts/new"
      end

      role.project_module :comments do |project|
        project.menu :list, "/admin/comments.js"
        project.menu :new,  "/admin/comments/new"
      end

      # Put before other permissions [don't delete this line!!!]
    end

  end
end