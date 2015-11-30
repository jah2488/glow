class Assign < Node
  attr_reader :target, :value
  def initialize(target, value)
    @target = target.to_s.strip
    @value  = value
  end

  def type(ctx)
    ctx.store(target, value.type(ctx))
  end

  def eval(env)
    env.store(target, value.eval(env))
  end

  def inspect
    "Assign(#{target} = #{value.inspect})"
  end
end
