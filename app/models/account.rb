class Account
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :name, String
  property :surname, String
  property :email, String
  property :crypted_password, String
  property :salt, String
  property :role, String
  
  has n, :posts
end
