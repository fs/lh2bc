module Basecamp
  class Project < Record
    class << self
      # Return the list of all accessible projects
      def list
        records "/project/list" 
      end
    end
    
    # def messages(options = {})
    #   Message.list(id, options)
    # end
    # 
    # def message_archive(options = {})
    #   @message_archive ||= Message.archive(id, options)
    # end
    # 
    # def milestones(find="all")
    #   Milestone.list(id, find)
    # end
  end
end
