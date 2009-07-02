require File.dirname(__FILE__) + '/../../spec_helper.rb'

describe Basecamp::Record do
  before(:each) do
    # @base = mock('Base')
    # Basecamp::Base.stub!(:new).and_return(@base)
  end
  
  describe "init from xml" do
    before(:each) do
      xml_data = '<?xml version="1.0" encoding="UTF-8"?>
<projects type="array">
  <project>
    <announcement nil="true"></announcement>
    <created-on type="date">2009-02-02</created-on>
    <id type="integer">2864720</id>
    <last-changed-on type="datetime">2009-02-13T09:58:41Z</last-changed-on>
    <name>ProductMadness - Development</name>
    <show-announcement type="boolean">false</show-announcement>
    <show-writeboards type="boolean">true</show-writeboards>
    <start-page>log</start-page>
    <status>active</status>
    <company>
      <id type="integer">1255848</id>
      <name>Product Madness</name>
    </company>
  </project>
</projects>'
      
      @response = mock('Response', :body => xml_data, :code => 200)
      @connection = mock('Connection', :post => @response)
      Basecamp::Base.stub!(:connection).and_return(@connection)
      @projects = Basecamp::Project.list
      @project = @projects.first
    end
    
    it "should initialize correct object from xml" do  
      @projects.should be_a(Array)
    end
    
    it "should return array of projects" do
      @project.should be_a(Basecamp::Project)
    end
    
    it "should provide accessors for all attributes" do
      @project.announcement.should == nil
      @project.created_on.should == Date.parse('2009-02-02')
      @project.id.should == 2864720
      @project.last_changed_on.should == Time.parse('2009-02-13T09:58:41Z')
      @project.name.should == 'ProductMadness - Development'
      @project.show_announcement.should == false
      @project.show_writeboards.should == true
      @project.start_page.should == 'log'
      @project.status.should == 'active'
    end    
  end
end
