class ControlFlow < Node
end

class If < ControlFlow
  attr_reader :predicate, :body, :true_body, :false_body
  def initialize(predicate, true_body, false_body)
    @predicate = predicate
    @body = true_body
    @true_body  = true_body
    @false_body = false_body
  end

  def eval(env)
    pred = predicate.eval(env)
    if pred.is_a?(True) || pred == "true"
      true_body.map { |node| node.eval(env) }
    else
      false_body.map { |node| node.eval(env) }
    end
  end

  def inspect
    "<If (#@predicate) {#@true_body} else {#@false_body}"
  end
end
