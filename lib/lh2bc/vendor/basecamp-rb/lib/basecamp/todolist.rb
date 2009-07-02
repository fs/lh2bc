module Basecamp
  class TodoList < Resource
    parent_resources :project
    
    def todo_items(options={})
      @todo_items ||= TodoItem.find(:all, :params => options.merge(:todo_list_id => id))
    end
    
    class << self
      # Returns all lists for a project. If complete is true, only completed lists
      # are returned. If complete is false, only uncompleted lists are returned.
      def all(project_id, complete=nil)
        filter = case complete
          when nil   then "all"
          when true  then "finished"
          when false then "pending"
          else raise ArgumentError, "invalid value for `complete'"
        end

        find(:all, :params => { :project_id => project_id, :filter => filter })
      end
    end
  end
end