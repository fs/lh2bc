require File.dirname(__FILE__) + '/../../spec_helper.rb'

describe Basecamp::TodoItem do
  before(:all) do
    establish_connection
    @todo = create_todo_list_for_project_with_todo(TEST_PROJECT_ID)
  end
  
  after(:all) do
    Basecamp::TodoList.delete(@todo.todo_list_id)
  end
  
  it "should have todo list" do
    @todo.todo_list.should_not be_blank
  end
  
  it "should return list of comments" do
    @todo.comments.should_not be_blank
    @todo.comments.should be_kind_of(Array)
  end
  
  it "should return array of time entries" do
    @todo.time_entries.should be_kind_of(Array)
  end
  
  it "should complete todo item" do
    @todo.complete!
    todo = Basecamp::TodoItem.find(@todo.id)
    todo.completed.should == true
  end
  
  it "should uncomplete todo item" do
    @todo.uncomplete!
    todo = Basecamp::TodoItem.find(@todo.id)
    todo.completed.should == false
  end
end
