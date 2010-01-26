class Post
  include DataMapper::Resource

  property   :id,         Serial
  property   :permalink,  String
  property   :title,      String, :required => true
  property   :body,       Text,   :required => true
  property   :created_at, DateTime
  property   :num_views,  Integer, :default => 0

  belongs_to :account
  has n, :comments, :constraint => :destroy

  before :save,   :generate_permalink

  def self.match_query(query)
   query ? all(:conditions => ["title LIKE ? OR body LIKE ?", "%#{query}%", "%#{query}%"]) : all
  end

  def to_param
    self.permalink
  end

  def self.from_param(param)
    self.first(:permalink => param)
  end

  protected
    def generate_permalink
      self.permalink = self.title.downcase.gsub(/\W/, '_').gsub(/_+/, '_').gsub(/_$/, '').gsub(/^_/, '')
    end
end