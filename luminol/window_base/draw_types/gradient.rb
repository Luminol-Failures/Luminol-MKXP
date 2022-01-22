class GradientInstruction
  def initialize(options = {})
    @rect = options[:rect]
    @color1 = options[:color1]
    @color2 = options[:color2]
    @vertical = options[:vertical]
    @vertical ||= false
  end

  def draw(bitmap)
    bitmap.gradient_fill_rect(@rect, @color1, @color2, @vertical)
  end
end
