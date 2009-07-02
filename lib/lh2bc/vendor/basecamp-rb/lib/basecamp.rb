$:.unshift File.dirname(__FILE__)

require 'yaml'
require 'date'
require 'time'
require 'xmlsimple'
require 'activeresource'

require 'basecamp/base'
require 'basecamp/resource'
require 'basecamp/record'
require 'basecamp/attachment'
require 'basecamp/comment'
require 'basecamp/company'
require 'basecamp/connection'
require 'basecamp/attachment_category'
require 'basecamp/message'
require 'basecamp/milestone'
require 'basecamp/project'
require 'basecamp/person'
require 'basecamp/post_category'
require 'basecamp/time_entry'
require 'basecamp/todoitem'
require 'basecamp/todolist'

# A minor hack to let Xml-Simple serialize symbolic keys in hashes
class Symbol
  def [](*args)
    to_s[*args]
  end
end

class Hash
  def to_legacy_xml
    XmlSimple.xml_out({:request => self}, 'keeproot' => true, 'noattr' => true)
  end
end