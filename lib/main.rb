require 'pry'
require 'parslet'
require_relative 'utils'
require_relative 'nodes'
require_relative 'types'
require_relative 'transform'
require_relative 'parser'

src = '
n = 5

last = fn ( x : Int, y : Int ): Int { y }
fn first(x:Int, y:Int):Int { 1 }

last(10, n)
first(10, n)

if (true) {
  x = 10
  first(n, x)
} else {
  last(n, x)
}
'

def nodes(src)
  GLTransform.new.apply(GLParser.new.parse(src)).tap { |s| puts "Nodes: #{s.inspect}" }
rescue Parslet::ParseFailed => e
  puts e, e.cause.ascii_tree
end

def type_check(src)
  ctx = {}
  nodes(src).map do |node|
    node.type(ctx)
  end
end

def interpret(src)
  env = {}
  nodes(src).map do |node|
    node.eval(env)
  end
end

puts "Running:
#{type_check(src)
    .map(&:inspect)
    .zip(interpret(src)
    .map(&:inspect))
    .map {|x|x.join(' -> ')}
    .map.with_index {|x, i| "(#{i+1}) #{x}"}
    .join("\n")}"
