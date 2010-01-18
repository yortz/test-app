class Account
  include DataMapper::Resource

  property :id,      Serial
  property :name,    String
  property :surname, String
  property :avatar,  String

  has n, :posts
end