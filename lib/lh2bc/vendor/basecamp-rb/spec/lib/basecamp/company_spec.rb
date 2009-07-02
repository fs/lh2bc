require File.dirname(__FILE__) + '/../../spec_helper.rb'

describe Basecamp::Company do
  before(:each) do
    establish_connection
  end
  
  it "should return information for the company with the given id" do
    company = Basecamp::Company.find(TEST_COMPANY_ID)
    company.should_not be_blank
    company.name.should_not be_blank
  end
end
