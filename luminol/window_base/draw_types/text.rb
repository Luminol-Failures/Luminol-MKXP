class TextInstruction
  def initialize(options = {})
    @text = options[:text]
    @align = options[:align]
    @align ||= 0
    @x = options[:x]
    @y = options[:y]
  end

  def draw(bitmap)
    rect = bitmap.text_size(@text)
    rect.x = @x; rect.y = @y
    bitmap.draw_text(rect, @text, @align)
  end
end
