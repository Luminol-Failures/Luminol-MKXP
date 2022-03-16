class Widget
  attr_reader :rect, :x, :y, :width, :height
  attr_accessor :visible, :ox, :oy

  def initialize(rect, options = {})
    @rect = rect
    @options = options

    @x = @rect.x
    @y = @rect.y
    @width = @rect.width
    @height = @rect.height

    @clipped_region = nil
    @visible = true

    @ox = 0
    @oy = 0
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
    @selected && @visible
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

  def mouse_inside_widget?(window)
    inside?(window, Input.mouse_x, Input.mouse_y)
  end

  def get_mouse_pos(window = nil) # RELATIVE TO WIDGET!!
    mx = Input.mouse_x + @ox - 16 - self.x
    my = Input.mouse_y + @oy - 16 - self.y

    mx -= window.x unless window.nil?
    my -= window.y unless window.nil?

    return mx, my
  end
end
