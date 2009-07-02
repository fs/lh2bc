require File.dirname(__FILE__) + '/../../spec_helper.rb'

describe Basecamp::Milestone do
  before(:all) do
   establish_connection
   @milestones = [create_milestone_for_project(TEST_PROJECT_ID)]
  end
  
  after(:all) do
    @milestones.each {|m| m.destroy }
  end
  
  it "should return a list of all milestones for the given project" do
    milestones = Basecamp::Milestone.list(TEST_PROJECT_ID)
    milestones.should be_kind_of(Array)
    milestones.should_not be_blank
  end
  
  it "should create a new milestone for given project" do
    milestones = Basecamp::Milestone.create(TEST_PROJECT_ID,
      :title             => 'new',
      :responsible_party => TEST_PERSON_ID,
      :deadline          => Time.now,
      :notify            => false
    )
    
    milestones.should_not be_blank
    @milestones << milestones
  end
  
  it "should complete milestone" do
    milestone = Basecamp::Milestone.list(TEST_PROJECT_ID).first
    milestone.complete!.completed.should be_true
  end
  
  it "should uncomplete milestone" do
    milestone = Basecamp::Milestone.list(TEST_PROJECT_ID).first
    milestone.uncomplete!.completed.should be_false
  end
  
  it "should destroy all milestones" do
    lambda { create_milestone_for_project(TEST_PROJECT_ID).destroy }.should_not raise_error
  end
end
