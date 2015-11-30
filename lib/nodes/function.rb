class Function < Node
  attr_reader :params, :body, :return_type, :name
  def initialize(params, body, return_type, name = "Anonymous")
    @params = params
    @body   = body
    @name   = name.to_s.strip
    @return_type = return_type
  end

  def type(ctx)
    ctx.store(name, FunctionType.new(self, ctx)) unless name == 'Anonymous'
    FunctionType.new(self, ctx)
  end

  def eval(env)
    env.store(name, self) unless name == 'Anonymous'
    self
  end

  def call(arg_values, env)
    call_env = {}.merge(parent: env)

    params.each.with_index do |param, i|
      call_env.store(param.name, arg_values[i])
    end

    body.map { |node| node.eval(call_env) }.last
  end

  def inspect
    "<Function #{name}(#{params.join(', ')}):#{return_type}>"
  end
end
