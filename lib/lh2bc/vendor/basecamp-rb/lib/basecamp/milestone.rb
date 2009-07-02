module Basecamp
  class Milestone < Record
    # Updates an existing milestone.
    def update_attributes(params = {})
      data = params.dup
      move = data.delete :move
      move_off_weekends = data.delete :move_off_weekends
      record "/milestones/update/#{id}",
        :milestone                             => data,
        :move_upcoming_milestones              => move,
        :move_upcoming_milestones_off_weekends => move_off_weekends 
    end
   
    # Destroys the milestone
    def destroy
      record "/milestones/delete/#{id}"
    end

    # Complete the milestone 
    def complete!
      record "/milestones/complete/#{id}"
    end 
    
    # Uncomplete the milestone
    def uncomplete!
      record "/milestones/uncomplete/#{id}"
    end

    class << self
      def list(project_id, find = "all")
        records "/projects/#{project_id}/milestones/list", :find => find
      end
   
      # Create a new milestone for the given project. +data+ must be hash of the
      # values to set, including +title+, +deadline+, +responsible_party+, and
      # +notify+.
      def create(project_id, data = {})
        create_milestones(project_id, [data]).first
      end
    

      # As #create_milestone, but can create multiple milestones in a single
      # request. The +milestones+ parameter must be an array of milestone values as
      # descrbed in #create_milestone.
      def create_milestones(project_id, milestones)
        records "/projects/#{project_id}/milestones/create", :milestone => milestones
      end
    end
  end
end
