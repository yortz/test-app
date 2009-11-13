module HassleInitializer
  def self.registered(app)
    app.use Hassle
  end
end
