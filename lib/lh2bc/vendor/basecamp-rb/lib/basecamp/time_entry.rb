module Basecamp
  class TimeEntry < Resource
    parent_resources :project, :todo_item
    
    def todo_item(options={})
      @todo_item ||= todo_item_id && TodoItem.find(todo_item_id, options)
    end
    
    class << self
      def all(project_id, page=0)
        find(:all, :params => { :project_id => project_id, :page => page })
      end

      def report(options={})
        find(:all, :from => :report, :params => options)
      end
    end
  end
end
