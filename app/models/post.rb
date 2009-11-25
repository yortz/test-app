class Post
  include DataMapper::Resource

  # property <name>, <type>
  property :id,       Serial
  property :permalink, String
  property :title, String
  property :body, Text
  property :author_id, Integer
  property :created_at, DateTime
  property :num_views, Integer
  
  has n, :comments
  
  before :save, :generate_permalink
  before :create, :generate_created_at
  
  def to_param
    self.permalink
  end
  
  def self.from_param(param)
    self.first(:permalink => param)
  end
  
  protected
  
  def generate_created_at
    self.created_at = Time.now
  end
  
  def generate_permalink
    self.permalink = self.title.downcase.gsub(/\W/, '_').gsub(/_+/, '_').gsub(/_$/, '').gsub(/^_/, '')
  end
end