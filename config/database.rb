module DatabaseSetup
  def self.registered(app)
    app.configure(:development) { DataMapper.setup(:default, 'sqlite3://your_dev_db_here') }
    app.configure(:production)  { DataMapper.setup(:default, 'sqlite3://your_production_db_here') }
    app.configure(:test)        { DataMapper.setup(:default, 'sqlite3://your_test_db_here') }
  rescue ArgumentError => e
    puts "Database options need to be configured within 'config/database.rb'!" if app.logging?
  end
end
