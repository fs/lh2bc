require File.dirname(__FILE__) + '/../../spec_helper.rb'

describe Basecamp::PostCategory do
  before(:each) do
    establish_connection
  end
  
  it "should return the list of message categories for the given project" do
    categories  = Basecamp::PostCategory.list(TEST_PROJECT_ID)
    categories.should_not be_blank
    categories.should be_kind_of(Array)
  end
end
