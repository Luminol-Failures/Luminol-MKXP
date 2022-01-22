require_relative "window_base"

class Window_Selectable < Window_Base
  def initialize(x, y, width, height)
    super(x, y, width, height)
    @widgets = {}

    @cursor_x = 0
    @cursor_y = 0
    @cursor_width = 0
    @cursor_height = 0
  end

  def add_widget(id, widget)
    @widgets[id] = widget
  end

  def update
    super()
    widget_selected = false
    @widgets.each do |id, widget|
      widget.update

      if widget.selected?
        widget_selected = true
        @cursor_x = widget.x - 3 # Add padding of 3 pixels
        @cursor_y = widget.y - 3  # Add padding of 3 pixels
        @cursor_width = widget.width + 6 # Add padding of 6 pixels
        @cursor_height = widget.height + 6 # Add padding of 6 pixels

        update_cursor
      end
    end
    unless widget_selected
      self.cursor_rect.empty
    end
  end

  def widget(id)
    @widgets[id]
  end

  def draw()
    super()
    @widgets.each { |id, widget| widget.draw(self.contents) }
  end

  def remove_widget(id)
    @widgets.delete(id)
  end

  def update_cursor
    self.cursor_rect.set(@cursor_x, @cursor_y, @cursor_width, @cursor_height)
  end
end
