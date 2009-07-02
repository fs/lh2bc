module Basecamp
  class Person < Record
    class << self
      # Return an array of the people in the given company. If the project-id is
      # given, only people who have access to the given project will be returned.
      def list(company_id, project_id = nil)
        url = project_id ? "/projects/#{project_id}" : ""
        url << "/contacts/people/#{company_id}"
        records url
      end

      # Return information about the person with the given id
      def find(id)
        record "/contacts/person/#{id}"
      end
    end
  end
end
