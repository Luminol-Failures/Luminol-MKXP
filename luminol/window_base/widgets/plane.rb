require_relative 'widget'
class PlaneWidget < Widget
  def initialize(rect, options = {})
    super(rect, options)
    @widgets = {}
  end

  def add_widget(id, widget)
    @widgets[id] = widget
  end

  def draw(bitmap)
    return unless super bitmap

    @widgets.each do |_, widget|
      widget.draw(bitmap)
    end
  end

  def update(window)
    return unless super window

    @widgets.each do |_, widget|
      widget.update(window)
    end
  end
end
