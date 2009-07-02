# === Attaching Files to a Resource
#
# If the resource accepts file attachments, the +attachments+ parameter should
# be an array of Basecamp::Attachment objects. Example:
#
#   a1 = Basecamp::Atachment.create('primary', File.read('primary.doc'))
#   a2 = Basecamp::Atachment.create('another', File.read('another.doc'))
#
#   m = Basecamp::Message.new(:project_id => 1037)
#   ...
#   m.attachments = [a1, a2]
#   m.save # => true
#
module Basecamp
  class Attachment       
     attr_accessor :id, :filename, :content, :content_type
     
     def initialize(filename, content, content_type = 'application/octet-stream')
       @filename, @content, @content_type = filename, content, content_type
     end

     def attributes
       { :file => id, :original_filename => filename, :content_type => content_type }
     end

     def to_xml(options = {})
       { :file => attributes }.to_xml(options)
     end

     def inspect
       to_s
     end

     def save
       response = Basecamp::Base.connection.post('/upload', content, 'Content-Type' => content_type)

       if response.code == '200'
         self.id = Hash.from_xml(response.body)['upload']['id']
         true
       else
         raise "Could not save attachment: #{response.message} (#{response.code})"
       end
     end
     
     class << self
       def create(filename, content)
         returning new(filename, content) do |attachment|
           attachment.save
         end
       end
     end
  end
end
