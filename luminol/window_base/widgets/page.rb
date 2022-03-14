require_relative 'widget'

class Page < Widget
  attr_accessor :clipped_region

  def initialize(rect, options = {})
    super(rect, options)

    @widgets = []
    @pages = []
  end

  def update(window)
    return unless super window

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
end
