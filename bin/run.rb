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
    puts e, e.cause.ascii_tree
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
    [output, env]
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
    binding.pry
  end
end

runner = Run.new
puts "(R)run REPL"
puts "(P)ry"
case gets.chomp.upcase
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
