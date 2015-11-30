class Param < Node
  attr_reader :name, :type
  def initialize(name, type)
    @name = name
    @type = type
  end

  def accepts?(other_type)
    other_type == type ||
    alias_of?(other_type) ||
    subset_of?(other_type) ||
    union_of?(other_type)
  end

  def refuse?(other_type)
    !accepts?(other_type)
  end

  def to_s
    [name, ':', type].join
  end

  private
  def alias_of?(other_type)
    other_type.aliases.include?(type)
  end

  def subset_of?(other_type)
    # (A ∩ B) ⊆ A
  end

  def union_of?(other_type)
    # A ⊆ B  ⇔  (A ∪ B) = B
  end

end
