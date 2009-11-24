class Post
  include DataMapper::Resource

  # property <name>, <type>
  property :id,       Serial
  property :title, String
  property :body, Text
  property :author_id, Integer
end