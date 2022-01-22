class ColorInstruction
  def initialize(options = {})
    @rect = options[:rect]
    @color = options[:color]
  end

  def draw(bitmap)
    bitmap.fill_rect(@rect, @color)
  end
end
