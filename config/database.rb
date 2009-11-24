module DatabaseSetup
  def self.registered(app)
    app.configure(:development) { DataMapper.setup(:default, "sqlite3://" + Padrino.root('db', "blog_#{Padrino.env.to_s}.db")) }
    app.configure(:production)  { DataMapper.setup(:default, "sqlite3://" + Padrino.root('db', "blog_#{Padrino.env.to_s}.db")) }
    app.configure(:test)        { DataMapper.setup(:default, "sqlite3://" + Padrino.root('db', "blog_#{Padrino.env.to_s}.db")) }
  rescue ArgumentError => e
    logger.error "Database options need to be configured within 'config/database.rb'!" if app.logging?
  end
end
