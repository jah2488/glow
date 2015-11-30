require './lib/types/type'
files = (Dir['lib/types/*.rb'] - ['lib/types/type.rb'])
files.each {|f| require './' + f }
