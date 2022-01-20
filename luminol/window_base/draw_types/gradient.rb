class GradientInstruction
  def initialize(rect, color1, color2, vertical = false)
    @rect = rect
    @color1 = color1
    @color2 = color2
    @vertical = vertical
  end

  def draw(bitmap)
    bitmap.gradient_fill_rect(@rect, @color1, @color2, @vertical)
  end
end
