class TreeNode
  attr_accessor :parent, :children, :name, :data, :opened

  def initialize(name, data, children = [], opened = false)
    @name = name
    @data = data
    @children = children
    @opened = opened
  end

  def add_child(child)
    @children << child
    child.parent = self
  end

  def remove_child(child)
    @children.delete(child)
    child.parent = nil
  end

  alias :<< :add_child
  alias :>> :remove_child

  def to_s
    @name
  end

  def each(&block)
    @children.each { |c| c.each(&block) }
  end
end
