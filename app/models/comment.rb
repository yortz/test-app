class Comment
  include DataMapper::Resource

  property :id,          Serial
  property :post_id,     Integer
  property :author_name, String
  property :email,       String
  property :website,     String
  property :body,        Text
  property :created_at,  DateTime
  
  belongs_to :post
  
  before :create, :generate_created_at
  
  protected
  
  def generate_created_at
    self.created_at = Time.now
  end
end
