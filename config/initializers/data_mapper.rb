module DataMapperInitializer
  def self.registered(app)
    app.configure(:development) { DataMapper.setup(:default, 'sqlite3::memory:') }
    app.configure(:production)  { DataMapper.setup(:default, 'sqlite3::memory:') }
    app.configure(:test)        { DataMapper.setup(:default, 'sqlite3::memory:') }
  end
end
