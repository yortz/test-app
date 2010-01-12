class Account
  include DataMapper::Resource

  property :id,      Serial
  property :name,    String, :required => true
  property :surname, String, :required => true

  has n, :posts

end