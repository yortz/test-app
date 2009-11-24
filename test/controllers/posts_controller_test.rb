require File.dirname(__FILE__) + '/../test_config.rb'

describe "PostsController" do
  it 'returns text at root' do
    get '/'
    last_response.body.should == "some text"
  end
end
