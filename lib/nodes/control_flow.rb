class ControlFlow < Node
end

class If < ControlFlow
  attr_reader :predicate, :body
  def initialize(predicate, true_body, false_body)
    @predicate = predicate
    @body = true_body
    @true_body  = true_body
    @false_body = false_body
  end

  def eval(env)
    pred = predicate.eval(env)
    unless pred.nil? || pred == "false"
      body.map { |node| node.eval(env) }
    end
  end

  def inspect
    "<If (#@predicate) {#@body}"
  end
end
