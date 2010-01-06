class Account
  include DataMapper::Resource
  
  property :id, Serial
  property :role, String
end