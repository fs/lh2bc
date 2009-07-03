require 'rubygems'
require 'activesupport'



# read

puts({:a => {:b => :c}}.path(':a/:b').inspect)
puts({'a' => {'b' => 'c'}}.path('a/b').inspect)
puts({'a' => {:b => :c}}.path('a/:b').inspect)
puts({'a' => {'b' => :c}}.path('a/b').inspect)


# write
h = {'a' => {'b' => {}}}
h.path('a', 1)
puts(h.inspect)