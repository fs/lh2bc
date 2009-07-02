require File.dirname(__FILE__) + '/../../spec_helper.rb'

describe Basecamp::Attachment do  
  before(:each) do
    establish_connection
  end
  
  it "should create attachments for comment" do
    a1 = Basecamp::Attachment.create('test1', File.read(File.dirname(__FILE__) + '/../../fixtures/attachment1'))
    a2 = Basecamp::Attachment.create('test2', File.read(File.dirname(__FILE__) + '/../../fixtures/attachment2'))
    
    comment = Basecamp::Comment.new(:post_id => TEST_MESSAGE_ID)
    comment.body = "test comment with attachment"
    comment.attachments = [a1, a2]
    comment.save
    comment_id = comment.id
    
    comment = Basecamp::Comment.find(comment_id)
    
    a1.should_not be_blank
    a1.should_not be_blank
    comment.attachments_count.should == 2
    
    Basecamp::Comment.delete(comment_id)
  end
end
