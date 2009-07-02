require File.dirname(__FILE__) + '/../../spec_helper.rb'

describe Basecamp::Person do
  before(:each) do
    establish_connection
  end
  
  it "should find person with the given id" do
    person = Basecamp::Person.find(TEST_PERSON_ID)
    person.should_not be_blank
  end
  
  it "should return an array of the people in the given company" do
    people = Basecamp::Person.list((TEST_COMPANY_ID)) 
    people.should_not be_blank
    people.should be_kind_of(Array)
  end
end
