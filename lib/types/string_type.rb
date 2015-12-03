class StringType < Type
  def inspect
    'String'
  end

  def aliases
    [
      "Str",
      "Chars",
    ]
  end
end
