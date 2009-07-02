require File.dirname(__FILE__) + '/../../spec_helper.rb'

describe Basecamp::Message do
  before(:each) do
    establish_connection
  end
  
  it "should return the most recent 25 messages in the given project" do
    messages = Basecamp::Message.list(TEST_PROJECT_ID)
    messages.should_not be_blank
    messages.should be_kind_of(Array)
    messages.size.should_not > 25
  end
  
  it "should get a list of messages for given project and specified category" do
    category_id = Basecamp::Message.find(TEST_MESSAGE_ID).category_id
    messages = Basecamp::Message.list(TEST_PROJECT_ID, :category_id => category_id)
    messages.should_not be_blank
    messages.should be_kind_of(Array)
    messages.each{ |m| m.category_id.should == category_id }
  end
  
  it "should return a summary of all messages in the given project" do
    messages = Basecamp::Message.archive(TEST_PROJECT_ID)
    messages.should_not be_blank
    messages.should be_kind_of(Array)
  end
  
  it "should return a summary of all messages in the given project and specified category " do
    category_id = Basecamp::Message.find(TEST_MESSAGE_ID).category_id
    messages = Basecamp::Message.archive(TEST_PROJECT_ID, :category_id => category_id)
    messages.should_not be_blank
    messages.should be_kind_of(Array)
  end
  
  it "should return list of message comments" do
    create_comments_for_message(TEST_MESSAGE_ID)
    
    message = Basecamp::Message.find(TEST_MESSAGE_ID)
    message.comments.should_not be_blank
    message.comments.should be_kind_of(Array)
    
    delete_comments_for_message(TEST_MESSAGE_ID)
  end
end
