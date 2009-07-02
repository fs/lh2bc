# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{basecamp-rb}
  s.version = "0.0.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["The Turing Studio, Inc."]
  s.date = %q{2009-03-05}
  s.description = %q{A Ruby gem for working with the Basecamp web-services API.}
  s.email = ["support@turingstudio.com"]
  s.files = ["History.txt", "README.rdoc", "Rakefile", "lib/basecamp.rb", "lib/basecamp/attachment.rb", "lib/basecamp/attachment_category.rb", "lib/basecamp/base.rb", "lib/basecamp/comment.rb", "lib/basecamp/company.rb", "lib/basecamp/connection.rb", "lib/basecamp/message.rb", "lib/basecamp/milestone.rb", "lib/basecamp/person.rb", "lib/basecamp/post_category.rb", "lib/basecamp/project.rb", "lib/basecamp/record.rb", "lib/basecamp/resource.rb", "lib/basecamp/time_entry.rb", "lib/basecamp/todoitem.rb", "lib/basecamp/todolist.rb", "lib/basecamp/version.rb", "spec/spec.opts", "spec/spec_helper.rb", "spec/lib/basecamp/attachment_category_spec.rb", "spec/lib/basecamp/attachment_spec.rb", "spec/lib/basecamp/base_spec.rb", "spec/lib/basecamp/company_spec.rb", "spec/lib/basecamp/message_spec.rb", "spec/lib/basecamp/milestone_spec.rb", "spec/lib/basecamp/person_spec.rb", "spec/lib/basecamp/post_category_spec.rb", "spec/lib/basecamp/project_spec.rb", "spec/lib/basecamp/record_spec.rb", "spec/lib/basecamp/time_entry_spec.rb", "spec/lib/basecamp/todo_item_spec.rb", "spec/lib/basecamp/todo_list_spec.rb", "tasks/rspec.rake"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/turingstudio/basecamp-rb/}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{A Ruby gem for working with the Basecamp web-services API.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<xml-simple>, [">= 1.0.11"])
      s.add_runtime_dependency(%q<activesupport>, [">= 2.2.2"])
      s.add_runtime_dependency(%q<activeresource>, [">= 2.2.2"])
    else
      s.add_dependency(%q<xml-simple>, [">= 1.0.11"])
      s.add_dependency(%q<activesupport>, [">= 2.2.2"])
      s.add_dependency(%q<activeresource>, [">= 2.2.2"])
    end
  else
    s.add_dependency(%q<xml-simple>, [">= 1.0.11"])
    s.add_dependency(%q<activesupport>, [">= 2.2.2"])
    s.add_dependency(%q<activeresource>, [">= 2.2.2"])
  end
end
