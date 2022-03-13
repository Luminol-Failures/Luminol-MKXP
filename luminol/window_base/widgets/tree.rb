class TreeWidget

end

class TreeNode
  attr_accessor :parent, :children, :name, :data

  def initialize(name, data)
    @name = name
    @data = data
    @children = []
  end

  def add_child(child)
    @children << child
    child.parent = self
  end

  def remove_child(child)
    @children.delete(child)
    child.parent = nil
  end

  def to_s
    @name
  end
end