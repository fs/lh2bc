begin
  require 'spec'
rescue LoadError
  require 'rubygems'
  gem 'rspec'
  require 'spec'
end

require File.dirname(__FILE__) + '/../lib/basecamp'

SITE_URL = 'bletchley.basecamphq.com'
LOGIN    = 'test'
PASSWORD = 'test'
USE_SSL  =  true

TEST_PROJECT_ID   = 2975113
TEST_MESSAGE_ID   = 20289953  # TEST_MESSAGE SHOULD BELONG TO TEST PROJECT!!!
TEST_COMPANY_ID   = 1287602
TEST_PERSON_ID    = 3509479

def establish_connection
  Basecamp::Base.establish_connection!(SITE_URL, LOGIN, PASSWORD, USE_SSL)
end

def create_comments_for_message(id)
  comment = Basecamp::Comment.new(:post_id => id)
  comment.body = "test comment"
  comment.save
end

def delete_comments_for_message(id)
  message = Basecamp::Message.find(id)
  message.comments.each {|c| Basecamp::Comment.delete(c.id)}
end

def create_time_entries_for_project_and_todo_item(project_id, todo_id)
  Basecamp::TimeEntry.create(
    :project_id  => project_id,
    :person_id   => TEST_PERSON_ID,
    :date        => Time.now,
    :hours       => '1.00',
    :description => 'test time entry'
  )

  entry = Basecamp::TimeEntry.create(
    :todo_item_id  => todo_id,
    :person_id     => TEST_PERSON_ID,
    :date          => Time.now,
    :hours         => '1.00',
    :description   => 'test time entry'
  )
  entry.todo_item_id = todo_id
  entry
end

def delete_time_entries_for_project(project_id)
  Basecamp::TimeEntry.all(project_id).each{ |entry| entry.destroy }
end

def create_todo_list_for_project_with_todo(id)
  todo_list = Basecamp::TodoList.create(
    :project_id   => id,
    :tracked      => true,
    :description  => 'private',
    :private      => false
  )
  todo = Basecamp::TodoItem.create(
    :todo_list_id => todo_list.id,
    :content      => 'Do it'
  )
  comment = Basecamp::Comment.new(:todo_item_id => todo.id)
  comment.body = "test comment"
  comment.save

  todo.todo_list_id = todo_list.id
  todo
end

def create_milestone_for_project(id)
  Basecamp::Milestone.create(TEST_PROJECT_ID,
    :title             => 'new',
    :responsible_party => TEST_PERSON_ID, 
    :deadline          => Time.now,
    :notify            => false
  )
end
