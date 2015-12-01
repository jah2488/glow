require 'pry'
require 'parslet'
require_relative '../lib/utils'
require_relative '../lib/nodes'
require_relative '../lib/types'
require_relative '../lib/transform'
require_relative '../lib/parser'

class Run
  def nodes(src)
    GLTransform.new.apply(GLParser.new.parse(src))#.tap { |s| puts "Nodes: #{s.inspect}" }
  rescue Parslet::ParseFailed => e
    cause = get_cause(e)
    line, col = cause.source.line_and_column
    str = src.split("\n")[line - 1]
    puts str
    puts cause.message
  end

  def get_cause(e)
    cause = e.cause.children.first
    until cause.children.empty?
      cause = cause.children.first
    end
    cause
  end

  def type_check(src, ctx = {})
    nodes(src).map do |node|
      node.type(ctx)
    end
    ctx
  end

  def interpret(src, env = {})
    output = nodes(src).map do |node|
      node.eval(env)
    end
    return [output, env]
  end

  def eval(src, ctx = {}, env = {})
    new_ctx = type_check(src, ctx)
    if new_ctx
      output, new_env = interpret(src, env)
      [output, new_ctx, new_env]
    end
  end

  def pry
    parser = GLParser.new
    trans  = GLTransform.new
    puts parser, trans
    binding.pry
  end
end

runner = Run.new
puts "(R)run REPL"
puts "(P)ry"
puts "(L)oad"
case gets.chomp.upcase
when "L"
  print "File name: "
  src = gets.chomp
  file = File.open(src).read
  puts runner.eval(file, {}, {})
when "R"
  input  = 'help = "hello world"'
  ctx    = {}
  env    = {}
  until input =~ /(exit|quit)/
    print 'gl > '
    input  = gets.chomp
    output = runner.eval(input, ctx, env)
    puts "#=> #{output[0]}"
    ctx = output[1]
    env = output[2]
  end
when "P"
  runner.pry
else
  exit
end
