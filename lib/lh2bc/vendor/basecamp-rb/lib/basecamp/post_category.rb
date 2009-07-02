module Basecamp
  class PostCategory < Record
    class << self
      # Returns the list of message categories for the given project
      def list(project_id)        
        records "/projects/#{project_id}/post_categories"
      end
    end
  end
end
