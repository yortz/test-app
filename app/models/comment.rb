class Comment
  include DataMapper::Resource

  property :id,          Serial
  property :post_id,     Integer, :required => true
  property :author_name, String,  :required => true
  property :email,       String,  :format => :email_address
  property :website,     String
  property :body,        Text,    :required => true
  timestamps :created_at

  belongs_to :post
end
