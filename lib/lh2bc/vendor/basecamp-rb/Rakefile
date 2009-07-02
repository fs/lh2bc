%w[rubygems rake rake/clean fileutils newgem rubigen].each { |f| require f }
require File.dirname(__FILE__) + '/lib/basecamp/version'

# Generate all the Rake tasks
# Run 'rake -T' to see list of generated tasks (from gem root directory)
$hoe = Hoe.new('basecamp-rb', Basecamp::VERSION) do |p|
  p.developer('The Turing Studio, Inc.', 'support@turingstudio.com')
  p.changes = p.paragraphs_of("History.txt", 0..1).join("\n\n")
  p.extra_deps = [
    ['xml-simple','>= 1.0.11'],
    ['activesupport','>= 2.2.2'],
    ['activeresource','>= 2.2.2']
  ]
  p.extra_dev_deps = [
    ['newgem', ">= #{::Newgem::VERSION}"]
  ]
  p.clean_globs |= %w[**/.DS_Store tmp *.log]
end

require 'newgem/tasks'
Dir['tasks/**/*.rake'].each { |t| load t }
