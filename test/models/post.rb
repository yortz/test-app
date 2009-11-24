require File.dirname(__FILE__) + '/../test_config.rb'

describe "Post Model" do
  it 'can be created' do
    @post = Post.new
    @post.should.not.be.nil
  end
end
