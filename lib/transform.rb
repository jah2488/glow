class GLTransform < Parslet::Transform
  rule(variable: simple(:identifier)) { Variable.new(identifier).with_location(identifier.line_and_column)}
  rule(number: simple(:digits)) { Number.new(digits).with_location(digits.line_and_column) }
  rule(string: simple(:chars)) { GLString.new(chars).with_location(chars.line_and_column) }
  rule(boolean: { true: simple(:bool)}) { True.new(bool) }
  rule(boolean: { false: simple(:bool)}) { False.new(bool) }
  rule(boolean: { and: simple(:bool)}) { And.new(bool) }
  rule(boolean: { not: simple(:bool)}) { Not.new(bool) }
  rule(boolean: { or: simple(:bool)}) { Or.new(bool) }

  rule(assign: { target: simple(:target), value: simple(:value) }) do
    Assign.new(target, value).with_location(target.line_and_column)
  end

  rule(name: simple(:name)) { name }
  rule(return_type: simple(:constant)) { constant.to_s.strip }
  rule(constant: simple(:constant)) { constant }
  rule(param: simple(:identifier), type: simple(:constant)) {  Param.new(identifier.to_s.strip, constant.to_s.strip).with_location(identifier.line_and_column) }
  rule(function: {
    params: sequence(:params),
    return_type: simple(:return_type),
    body: sequence(:body)
  }) do
    Function.new(params, body, return_type).with_location(return_type.line_and_column)
  end
  rule(function: {
    params: simple(:params),
    return_type: simple(:return_type),
    body: sequence(:body)
  }) do
    Function.new(params, body, return_type).with_location(return_type.line_and_column)
  end
  rule(named_function: {name: simple(:name), params: sequence(:params), body: sequence(:body), return_type: simple(:return_type) }) do
    Function.new(params, body, return_type, name).with_location(return_type.line_and_column)
  end

  rule(arg: simple(:arg)) { arg }
  rule(call: { target: simple(:target), args: simple(:args) }) do
    Call.new(target, args).with_location(target.line_and_column)
  end
  rule(call: { target: simple(:target), args: sequence(:args) }) do
    Call.new(target, args).with_location(target.line_and_column)
  end
end
