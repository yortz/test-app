require File.dirname(__FILE__) + '/../test_config.rb'

describe "Upload Model" do
  it 'can be created' do
    @upload = Upload.new
    @upload.should.not.be.nil
  end
end
