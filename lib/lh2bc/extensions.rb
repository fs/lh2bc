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
    completed
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
    "#<#{self.class} id: #{id}, title: #{title}, state: #{state}>"
  end

  def to_todo_item_content
    "##{id}, #{title}"
  end

  def completed?
    %w(accepted resolved).include?(state)
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
