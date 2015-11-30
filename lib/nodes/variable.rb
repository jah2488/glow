class Variable < Node

  def type(ctx)
    ctx.fetch(@value)
  end

  def eval(env)
    env.fetch(@value)
  end

  def to_s
    "<Variable #{@value}>"
  end
end
