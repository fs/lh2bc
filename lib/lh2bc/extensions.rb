require 'rubygems'
require 'activesupport'

class Hash
  class Path
    def initialize(hash)
      @hash = hash
    end

    def [](path)
      key, item = last_item(path)
      item[symbolize_key(key)]
    end

    def []=(path, value)
      key, item = last_item(path)
      item[symbolize_key(key)] = value
    end

    private

    def last_item(path)
      path = path.split('/')
      return path.pop, path.inject(@hash) { |hash, key| hash[symbolize_key(key)] }
    end

    def symbolize_key(key)
      key.start_with?(':') ? eval(key) : key
    end
  end

  def path
    Path.new(self)
  end
end

class String
  def to_lh_id
    match = self.match(/^\s*\#(\d+)/)
    return nil if match.nil?

    match[1].to_i
  end
end

class Basecamp::Resource
  def inspect
    "#<#{self.class} id: #{id}, name: #{respond_to?('name') ? name : content}>"
  end
end

class Basecamp::TodoItem
  def completed?
    respond_to?('completed') ? completed : false
  end
end

class Lighthouse::Project
  def inspect
    "#<#{self.class} id: #{id}, name: #{name}>"
  end

  def to_todo_list_name
    "##{id}, #{name}"
  end
end

class Lighthouse::Ticket
  def inspect
    "#<#{self.class} id: #{id}, title: #{title}, state: #{state}, user: #{attributes['assigned_user_id']}>"
  end

  def to_todo_item_content
    %Q{##{id}, <a href="#{url}">#{title}</a>}
  end

  def completed?
    Lh2Bc::Base.lh['resolved_states'].include?(state)
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
