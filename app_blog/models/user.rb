class User
  include DataMapper::Resource
  
  property :id,       Serial
  property :name,     String
  property :username, String
  property :email,    String
  property :crypted_password, String

  def self.authenticate(username, password)
    user = User.first(:username => username)
    user && user.has_password?(password) ? user : nil
  end
  
  def encrypt_password
    self.crypted_password = BCrypt::Password.create(password)
  end
  
  def has_password?(password)
    BCrypt::Password.new(crypted_password) == password
  end
end
