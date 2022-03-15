require_relative "../window_base/window_draggable"
require_relative "../window_base/widgets/button"

require_relative "window_projectpicker"
require_relative 'window_soundtest'

class Window_ToolBar < Window_Selectable
  def initialize
    super(0, 0, Graphics.width, 64)

    self.on_resize do |width, height|
      self.contents.dispose
      self.contents = Bitmap.new(self.width - 32, self.height - 32)
      self.width = width
      self.draw
    end

    @projectpicker = Window_ProjectPicker.new
    @soundtest = Window_SoundTest.new

    @toolbar_buttons = {
      project: Button.new(
        Rect.new(0, 0, 32, 32),
        pressed_icon: $system.button(:file),
        unpressed_icon: $system.button(:file),
      ),
      soundtest: Button.new(
        Rect.new(36, 0, 32, 32),
        pressed_icon: $system.button(:note),
        unpressed_icon: $system.button(:note),
        disabled: true
      )
    }

    @toolbar_buttons[:project].on_click do |state|
      @projectpicker.open
      @projectpicker.draw
    end

    @toolbar_buttons[:soundtest].on_click do |state|
      @soundtest.open
      @soundtest.draw
    end

    @toolbar_buttons.each do |id, button|
      self.add_widget(id, button)
    end
  end

  def update
    super
    @projectpicker.update
    @soundtest.update

    if project_selection_finished && @toolbar_buttons[:soundtest].disabled
      @toolbar_buttons[:soundtest].disabled = false
      draw
    end
  end

  def draw
    super
    @projectpicker.draw
    @soundtest.draw
  end

  def project_selection_finished
    @projectpicker.finished
  end
end
