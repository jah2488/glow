class Node
  attr_reader :value, :location
  def initialize(value, *args)
    @location = value.line_and_column
    @value = value.to_s.strip
    @args  = args
  end

  def type(_)
    'Type'
  end

  def eval(_)
    value
  end

  def inspect
    "<#{self.class} #{value}>"
  end

  def with_location(location)
    @location = location
    self
  end

  def empty?
    false
  end
end
