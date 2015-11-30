class Number < Node
  def type(_)
    NumberType.new
  end
  def eval(_)
    super
  end

  def to_s
    value
  end
  
  def inspect
    value
  end
end
