require File.dirname(__FILE__) + '/../../spec_helper.rb'

describe Basecamp::TodoList do
  before(:all) do
    establish_connection
    @todo = create_todo_list_for_project_with_todo(TEST_PROJECT_ID)
    @list = @todo.todo_list
  end
  
  after(:all) do
    Basecamp::TodoList.delete(@list.id)
  end
  
  it "should return todo items" do
    @list.todo_items.should_not be_blank
    @list.todo_items.should be_kind_of(Array)
  end
  
  it "should return all lists for a specified project" do
    lists = Basecamp::TodoList.all(TEST_PROJECT_ID)
    lists.should_not be_blank
    lists.should be_kind_of(Array)
  end
  
  it "should return all finished lists for a specified project" do
    lists = Basecamp::TodoList.all(TEST_PROJECT_ID, true)
    lists.should be_kind_of(Array)
    lists.each { |item| item.complete.should == "true" }
  end
  
  it "should return all pending lists for a specified project" do
    lists = Basecamp::TodoList.all(TEST_PROJECT_ID, false)
    lists.should be_kind_of(Array)
    lists.each { |item| item.complete.should == "false" }
  end
end
