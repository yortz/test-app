module DatabaseSetup
  def self.registered(app)
    app.configure(:development) { DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/blog_dev.db") }
    app.configure(:production)  { DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/blog_prod.db") }
    app.configure(:test)        { DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/blog_test.db") }
  rescue ArgumentError => e
    puts "Database options need to be configured within 'config/database.rb'!" if app.logging?
  end
end
