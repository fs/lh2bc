require File.dirname(__FILE__) + '/../../spec_helper.rb'

describe Basecamp::TimeEntry do
  before(:all) do
    establish_connection
    @todo = create_todo_list_for_project_with_todo(TEST_PROJECT_ID)
    @list = @todo.todo_list
    @entry = create_time_entries_for_project_and_todo_item(TEST_PROJECT_ID, @todo.id)
  end

  after(:all) do
    Basecamp::TodoList.delete(@list.id)
    delete_time_entries_for_project(TEST_PROJECT_ID)
  end

  it "should return all time entries" do
    entries = Basecamp::TimeEntry.report
    entries.should_not be_blank
    entries.should be_kind_of(Array)
  end
  
  it "should return all time entries for a specified project" do
    entries = Basecamp::TimeEntry.all(TEST_PROJECT_ID)
    entries.should_not be_blank
    entries.should be_kind_of(Array)
  end

  it "should return parent todo item" do
    @entry.todo_item.should_not be_blank
    @entry.todo_item.class.to_s.should == 'Basecamp::TodoItem'
  end
end
