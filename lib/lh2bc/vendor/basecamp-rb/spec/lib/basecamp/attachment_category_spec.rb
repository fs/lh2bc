require File.dirname(__FILE__) + '/../../spec_helper.rb'

describe Basecamp::AttachmentCategory do
  before(:each) do
    establish_connection
  end
  
  it "should return the list of file categories for the given project" do
    list = Basecamp::AttachmentCategory.list(TEST_PROJECT_ID)
    list.should be_kind_of(Array)
  end
end
