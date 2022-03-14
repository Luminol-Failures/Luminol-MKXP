class Widget
  attr_reader :rect, :x, :y, :width, :height
  attr_accessor :visible

  def initialize(rect, options = {})
    @rect = rect
    @options = options

    @x = @rect.x
    @y = @rect.y
    @width = @rect.width
    @height = @rect.height

    @clipped_region = nil
    @visible = true
  end

  def update(_window)
    return false unless @visible

    # Dummy method to be overridden by subclasses
    true
  end

  def draw(_bitmap)
    return false unless @visible

    # Dummy method to be overridden by subclasses
    true
  end

  def selected?
    @selected
  end

  def inside?(window, x, y)
    if @clipped_region
      x1 = @clipped_region.x + window.x + 16
      y1 = @clipped_region.y + window.y + 16
      x2 = x1 + @clipped_region.width
      y2 = y1 + @clipped_region.height
    else
      x1 = self.x + window.x + 16
      y1 = self.y + window.y + 16
      x2 = x1 + self.width
      y2 = y1 + self.height
    end

    return (x >= x1 && x <= x2 && y >= y1 && y <= y2)
  end
end
