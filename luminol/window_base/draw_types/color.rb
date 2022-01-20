class ColorInstruction
  def initialize(rect, color)
    @rect = rect
    @color = color
  end

  def initialize(x, y, width, height, color)
    @rect = Rect.new(x, y, width, height)
    @color = color
  end

  def draw(bitmap)
    bitmap.fill_rect(@rect, @color)
  end
end
