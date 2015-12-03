class ReturnTypeMismatch < StandardError
  attr_reader :type, :value
  def initialize(value, type)
    @type = type
    @value = value
  end

  def message
    "Type Error on Line #{Bold(type.line_and_column[0])} Column #{Bold(type.line_and_column[1])}. Return value is a #{Underline(value.inspect)}, but should be #{Underline(type.to_s.strip)}"
  end
end
class TypeMismatch < StandardError
  attr_reader :type, :param
  def initialize(param, type)
    @type = type
    @param = param
  end

  def message
    "Type Error on Line #{Bold(param.location[0])} Column #{Bold(param.location[1])}. Param :#{param.name} is a #{Underline(type.inspect)}, but should be #{Underline(param.type)}"
  end
end
class FunctionType < Type
  attr_reader :params, :body, :return_type, :init_ctx
  def initialize(fn, ctx)
    @params      = fn.params
    @body        = fn.body
    @init_ctx    = ctx
    @return_type = fn.return_type
  end

  def verify_types_and_return(arg_types, ctx)
    verify(arg_types)

    call_ctx = {}.merge(parent: ctx)

    params.each.with_index do |param, i|
      call_ctx.store(param.name, arg_types[i])
    end

    return_value = body.map { |node| node.type(call_ctx) }.last

    verify_return_value(return_value)

    return_value
  end

  def verify(types)
    param_type_pairs = params.zip(types)
    binding.pry
    param_type_pairs.each do |(param, type)|
      if param.refuse?(type)
        raise TypeMismatch.new(param, type)
      end
    end
  end

  def verify_return_value(value)
    unless value.aliases.include?(@return_type.to_s.strip)
      raise ReturnTypeMismatch.new(value, @return_type)
    end
  end

  def type
    "fn(#{params.join(', ')}):#{return_type}".strip
  end

  def inspect
    if params.length > 1
      "-> (#{params.join(', ')}) -> #{return_type}"
    else
      "-> #{return_type}"
    end
  end
end
