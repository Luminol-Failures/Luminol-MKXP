require_relative 'widget'
class PlaneWidget < Widget
  def initialize(rect, options = {})
    super(rect, options)
    @widgets = []
  end

  def add_widget(widget)
    @widgets << widget
  end

  def draw(bitmap)
    return unless super bitmap

    @widgets.each do |widget|
      widget.draw(bitmap)
    end
  end
end
