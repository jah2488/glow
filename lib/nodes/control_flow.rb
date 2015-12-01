class ControlFlow < Node
end

class If < ControlFlow
  attr_reader :predicate, :body
  def initialize(predicate, body)
    @predicate = predicate
    @body = body
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
