require_relative "../window_base/window_draggable"
require_relative "../window_base/widgets/button"

require_relative "window_projectpicker"

class Window_ToolBar < Window_Selectable
  def initialize
    super(0, 0, Graphics.width, 64)
    self.contents = Bitmap.new(self.width - 32, self.height - 32)

    self.on_resize do |width, height|
      self.contents.dispose
      self.contents = Bitmap.new(self.width - 32, self.height - 32)
      self.width = width
      self.draw
    end

    @projectpicker = Window_ProjectPicker.new

    @toolbar_buttons = {
      project: Button.new(
        Rect.new(0, 0, 32, 32),
        pressed_icon: $system.button(:file),
        unpressed_icon: $system.button(:file),
      ),
    }

    @toolbar_buttons[:project].on_click do |state|
      @projectpicker.open
      @projectpicker.draw
    end

    @toolbar_buttons.each do |id, button|
      self.add_widget(id, button)
    end
  end

  def update
    super
    @projectpicker.update
  end

  def draw
    super
    @projectpicker.draw
  end

  def project_selection_finished
    @projectpicker.finished
  end
end
