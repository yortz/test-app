module DatabaseSetup
  def self.registered(app)
    app.set :db_file, "sqlite3://" + Padrino.root('db', "blog_#{Padrino.env.to_s}.db")
    app.configure do 
      DataMapper.logger = logger
      DataMapper.setup(:default, app.db_file)
    end
  rescue ArgumentError => e
    logger.error "Database options need to be configured within 'config/database.rb'!" if app.logging?
  end
end