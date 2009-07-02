require File.dirname(__FILE__) + '/../../spec_helper.rb'

describe Basecamp::Project do
  before(:each) do
    establish_connection
  end
  
  it "should return the list of all accessible projects" do
    Basecamp::Project.list.should_not be_blank
    Basecamp::Project.list.should be_a_kind_of(Array)
  end
end
