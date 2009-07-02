class String
  def to_lh_id
    match = self.match(/^\s*\#(\d+)/)
    return nil if match.nil?
    
    match[1]
  end
end

class Basecamp::Resource
  def inspect
    "#<#{self.class} id: #{id}, name: #{respond_to?('name') ? name : content}>"
  end
end

module Lh2Bc
  class Base
    cattr_accessor :logger
    self.logger = Logger.new(STDOUT)

    cattr_accessor :bc_cred
    self.bc_cred = {
      :project_id => 3424579,
      :domain => 'flatsoft.grouphub.com',
      :username => 'id.timurv.ru/me',
      :password => '16965d28a4dd275bd243'
    }

    cattr_accessor :lh_cred
    self.lh_cred = {
      :domain => 'flatsoft',
      :signature => ''
    }

    def initialize(bc = {}, lh = {})
      self.bc_cred = bc.update(bc_cred)
      self.lh_cred = lh.update(lh_cred)

      logger.debug "* Initialize with BC: #{bc_cred.inspect}, LH: #{lh_cred.inspect}"
    end

    def sync
      esatblish_bc_connection
      load_bc_todo_lists
    end

    private

    def esatblish_bc_connection
      Basecamp::Base.establish_connection!(bc_cred[:domain], bc_cred[:username], bc_cred[:password], true)
    end

    def load_bc_todo_lists
      todo_lists = Basecamp::TodoList.all(bc_cred[:project_id])
      logger.debug "* Loaded BC todo lists: #{todo_lists.inspect}"

      @todo_lists_with_lh = returning({}) do |todo_lists_with_lh|
        todo_lists.each do |todo_list|
          project_id = todo_list.name.to_lh_id

          unless project_id.blank?
            todo_lists_with_lh[project_id] ||= {}
            todo_lists_with_lh[project_id][:list] = todo_list
            
            todo_list.todo_items.each do |todo_item|
              todo_item_id = todo_item.content.to_lh_id

              unless todo_item_id.blank?
                todo_lists_with_lh[project_id][todo_item_id] = todo_item
              end
            end
          end
        end
      end

      logger.debug "* Converted BC todo list in to LH hash: #{@todo_lists_with_lh.inspect}"
    end
  end
end