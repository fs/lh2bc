module Basecamp
  class Company < Record
    class << self
      def find(id)
        # Return information for the company with the given id      
        record "/contacts/company/#{id}"
      end
    end
  end
end
