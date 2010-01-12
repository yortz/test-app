module DatabaseSetup
  def self.registered(app)
    app.configure { DataMapper.logger = logger }
    app.set :db_file, "sqlite3://" + Padrino.root('db', "blog_#{Padrino.env.to_s}.db")
    app.configure(:development) { DataMapper.setup(:default, app.db_file) }
    app.configure(:production)  { DataMapper.setup(:default, app.db_file) }
    app.configure(:test)        { DataMapper.setup(:default, app.db_file) }
  rescue ArgumentError => e
    logger.error "Database options need to be configured within 'config/database.rb'!" if app.logging?
  end
end