require 'basecamp'
require 'lighthouse'

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

class Lighthouse::Project
  def inspect
    "#<#{self.class} id: #{id}, name: #{name}>"
  end
end

class Lighthouse::Ticket
  def inspect
    "#<#{self.class} id: #{id}, title: #{title}>"
  end
end

# Remove ugly hack from lh lib
module ActiveResource
  class Connection
    private
      def authorization_header
        (@user || @password ? { 'Authorization' => 'Basic ' + ["#{@user}:#{ @password}"].pack('m').delete("\r\n") } : {})
      end
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
      :account => 'flatsoft',
      :token => '2f0c1ffee6af44befaee7904a9cf8b455e9d48c9'
    }

    def initialize(bc = {}, lh = {})
      self.bc_cred = bc.update(bc_cred)
      self.lh_cred = lh.update(lh_cred)

      establish_bc_connection
      establish_lh_connection
    end

    def sync
      load_bc_todo_lists
      load_lh_projects
    end

    private

    def establish_bc_connection
      Basecamp::Base.establish_connection!(bc_cred[:domain], bc_cred[:username], bc_cred[:password], true)
      logger.debug "* Initialize BC: #{bc_cred.inspect}"
    end

    def load_bc_todo_lists
      todo_lists = Basecamp::TodoList.all(bc_cred[:project_id])
      logger.debug "* Loaded BC todo lists: #{todo_lists.inspect} for project #{bc_cred[:project_id]}"

      @todo_lists_with_lh_ids = returning({}) do |todo_lists_with_lh_ids|
        todo_lists.each do |todo_list|
          project_id = todo_list.name.to_lh_id

          unless project_id.blank?
            todo_lists_with_lh_ids[project_id] ||= {}
            todo_lists_with_lh_ids[project_id][:list] = todo_list
            
            todo_list.todo_items.each do |todo_item|
              todo_item_id = todo_item.content.to_lh_id

              unless todo_item_id.blank?
                todo_lists_with_lh_ids[project_id][todo_item_id] = todo_item
              end
            end
          end
        end
      end

      logger.debug "* Converted BC todo list in to LH hash: #{@todo_lists_with_lh_ids.inspect}"
    end

    def establish_lh_connection
      Lighthouse.account = lh_cred[:account]
      Lighthouse.token = lh_cred[:token]
      logger.debug "* Initialize LH: #{lh_cred.inspect}"
    end

    def load_lh_projects
      projects = Lighthouse::Project.find(:all)
      logger.debug "* Loaded LH projects: #{projects.inspect}"

      @projects_with_lh_ids = returning({}) do |projects_with_lh_ids|
        projects.each do |project|
          projects_with_lh_ids[project.id] ||= {}
          projects_with_lh_ids[project.id][:tikects] ||= {}
          projects_with_lh_ids[project.id][:project] = project

          project.tickets.each do |ticket|
            projects_with_lh_ids[project.id][:tikects][ticket.id] = ticket
          end
        end
      end

      logger.debug "* Converted LH projects to LH hash: #{@projects_with_lh_ids.inspect}"
    end
  end
end