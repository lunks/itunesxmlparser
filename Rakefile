# -*- ruby -*-

require 'rubygems'
require 'hoe'
require './lib/grok_itunes.rb'

Hoe.new('grok-itunes', GrokITunes::VERSION) do |p|
  p.rubyforge_name = 'uwruby'
  p.developer('John Howe', 'elf-rubyforge@arashi.com')
	p.extra_deps << [ 'sqlite3-ruby', '>= 1.2.4' ]
	p.extra_deps << [ 'scrobbler', '>= 0.2.1' ]
	p.extra_deps << [ 'ruby-treemap', '>= 0.0.3' ]
end

# vim: syntax=Ruby
