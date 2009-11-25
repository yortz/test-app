require File.dirname(__FILE__) + '/../test_config.rb'

describe "Comment Model" do
  it 'can be created' do
    @comment = Comment.new
    @comment.should.not.be.nil
  end
end
