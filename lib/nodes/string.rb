class GLString < Node
  def type(_)
    StringType.new
  end

  def eval(_)
    super
  end

  def to_s
    value
  end

  def inspect
    "<String #{value}"
  end
end
