module Lh2Bc
  class Base
    cattr_accessor :logger
    self.logger = Logger.new(STDOUT)

    cattr_accessor :bc_cred
    self.bc_cred = {
      :project_id => 3424579,
      :domain => 'flatsoft.grouphub.com',
      :username => 'test',
      :password => 'test'
    }

    cattr_accessor :lh_cred
    self.lh_cred = {
      :account => 'flatsoft',
      :token => 'test'
    }

    def initialize(options = {})
      self.bc_cred = bc_cred.update(options[:bc]) unless options[:bc].blank?
      self.lh_cred = lh_cred.update(options[:lh]) unless options[:lh].blank?

      establish_bc_connection
      establish_lh_connection
    end

    def sync
      load_bc_todo_lists
      load_lh_projects

      sync_todo
    end

    private

    def establish_bc_connection
      Basecamp::Base.establish_connection!(bc_cred[:domain], bc_cred[:username], bc_cred[:password], true)
      logger.debug "* Initialize BC: #{bc_cred.inspect}"
    end

    def load_bc_todo_lists
      todo_lists = Basecamp::TodoList.all(bc_cred[:project_id])
      logger.debug "* Loaded BC todo lists: #{todo_lists.inspect} for project #{bc_cred[:project_id]}"

      @todo_lists = returning({}) do |todo_lists_with_items|
        todo_lists.each do |todo_list|
          
          project_id = todo_list.name.to_lh_id
          unless project_id.blank?
            todo_lists_with_items[project_id] ||= {
              :list => todo_list
            }

            todo_list.todo_items.each do |todo_item|
              todo_item_id = todo_item.content.to_lh_id
              todo_lists_with_items[project_id][todo_item_id] = todo_item unless todo_item_id.blank?
            end
          end
        end
      end

      logger.debug "* Converted BC todo list in to LH hash: #{@todo_lists.inspect}"
    end

    def establish_lh_connection
      Lighthouse.account = lh_cred[:account]
      Lighthouse.token = lh_cred[:token]
      logger.debug "* Initialize LH: #{lh_cred.inspect}"
    end

    def load_lh_projects
      projects = Lighthouse::Project.find(:all)
      logger.debug "* Loaded LH projects: #{projects.inspect}"

      @projects = returning({}) do |projects_with_tickets|
        projects.each do |project|
          projects_with_tickets[project.id] = {
            :tickets => project.tickets,
            :project => project
          }
        end
      end

      logger.debug "* Converted LH projects to LH hash: #{@projects.inspect}"
    end

    def sync_todo
      @projects.keys.each do |project_id|
        sync_todo_lists_for(@projects[project_id][:project])
        sync_todo_items_for(@projects[project_id][:project], @projects[project_id][:tickets])
        sync_todo_items_state_for(@projects[project_id][:project], @projects[project_id][:tickets])
      end
    end

    def sync_todo_lists_for(project)
      unless @todo_lists.include?(project.id)
        todo_list = Basecamp::TodoList.create(
          :project_id => bc_cred[:project_id],
          :name =>  project.to_todo_list_name,
          :tracked => true
        )
        @todo_lists[project.id] = {:list => todo_list}

        logger.debug "* Created new todo list #{todo_list.inspect} for #{project.inspect}"
      else
        logger.debug "* Todo list for #{project.inspect} exists"
      end
    end

    def sync_todo_items_for(project, tickets)
      tickets.each do |ticket|
        unless @todo_lists[project.id].include?(ticket.id)
          todo_item = Basecamp::TodoItem.create(
            :todo_list_id => @todo_lists[project.id][:list].id,
            :content =>  ticket.to_todo_item_content
          )

          @todo_lists[project.id][ticket.id] = todo_item

          logger.debug "** Created new todo item #{todo_item.inspect} for #{ticket.inspect}"
        else
          logger.debug "** Todo item for #{ticket.inspect} exists"
        end
      end
    end

    def sync_todo_items_state_for(project, tickets)
      tickets.each do |ticket|
        todo_item = @todo_lists[project.id][ticket.id]
        unless todo_item.completed? == ticket.completed?
          todo_item.send(ticket.completed? ? 'complete!' : 'uncomplete!')
          logger.debug "** Sync completed state #{todo_item.inspect} for #{ticket.inspect}"
        else
        end
      end
    end
  end
end