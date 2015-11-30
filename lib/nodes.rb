require './lib/nodes/node'
files = (Dir['lib/nodes/*.rb'] - ['lib/nodes/node.rb'])
files.each {|f| require './' + f }
