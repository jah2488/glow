class Call < Node
  attr_reader :target, :args

  def initialize(target, args)
    @target = target.to_s.strip
    @args   = Array(args).reject(&:empty?)
  end

  def type(ctx)
    ft = ctx.fetch(target)
    arg_types = args.map { |arg| arg.type(ctx) }
    ft.verify_types_and_return(arg_types, ctx)
  end

  def eval(env)
    fn = env.fetch(target)
    vals = args.map { |arg| arg.eval(env) }
    fn.call(vals, env)
  end

  def inspect
    "<Call :#{target} [#{args.join(', ')}]>"
  end
end
