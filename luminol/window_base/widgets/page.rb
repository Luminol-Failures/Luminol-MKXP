class Page
  attr_reader :x , :y , :width , :height
  attr_accessor :clipped_region

  def initialize(rect, options = {})
    @x = rect.x
    @y = rect.y
    @width = rect.width
    @height = rect.height

    @rect = rect

    @widgets = []
    @pages = []
  end

  def update(window)
    @widgets.each { |widget| widget.update(window) }
      if MKXP.mouse_in_window
        mx = Input.mouse_x
        my = Input.mouse_y

        @selected = inside?(window, mx, my)
      end
    end

  def add_widget(widget, page)
    if widget.method(:clipped_region) # Check if widget has a clipped_region method
      widget.clipped_region = @rect
    end

    @widgets << widget
    @pages << page
  end

  def on_change(&block)
    @on_change = block
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