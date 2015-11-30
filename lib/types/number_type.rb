class NumberType < Type
  def inspect
    'Number'
  end

  def aliases
    [
      "Int",
      "Integer",
      "Num",
      "Number"
    ]
  end
end
