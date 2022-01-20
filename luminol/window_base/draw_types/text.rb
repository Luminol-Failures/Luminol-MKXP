class TextInstruction
  def initialize(text, x, y, align = 0)
    @text = text
    @align = align
    @x = x
    @y = y
  end

  def draw(bitmap)
    rect = bitmap.text_size(@text)
    rect.x = @x; rect.y = @y
    bitmap.draw_text(rect, @text, @align)
  end
end
