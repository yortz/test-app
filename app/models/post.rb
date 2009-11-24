class Post
  include DataMapper::Resource

  # property <name>, <type>
  property :id,       Serial
  property :permalink, String
  property :title, String
  property :body, Text
  property :author_id, Integer
  property :created_at, DateTime
  
  before :save, :generate_permalink
  
  def to_param
    self.permalink
  end
  
  def self.from_param(param)
    self.first(:permalink => param)
  end
  
  protected
  
  def generate_permalink
    self.permalink = self.title.downcase.gsub(/\W/, '_').gsub(/_+/, '_')
  end
end