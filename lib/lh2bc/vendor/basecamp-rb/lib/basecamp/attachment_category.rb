module Basecamp
  class AttachmentCategory < Record
    class << self
      # Returns the list of file categories for the given project
      def list(project_id)
        records "/projects/#{project_id}/attachment_categories"
      end
    end
  end
end
