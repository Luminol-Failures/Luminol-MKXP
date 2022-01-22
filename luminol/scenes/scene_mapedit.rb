require_relative "../window_base/window_selectable"
require_relative "../window_base/draw_types/draw_types"
require_relative "../window_base/widgets/button"

class Scene_MapEdit
  def main
    # Setup Scene
    Graphics.transition(40)

    @testwindow = Window_Selectable.new(0, 0, Graphics.width, Graphics.height)
    @testwindow.contents = Bitmap.new(@testwindow.width - 16, @testwindow.height - 16)
    @testwindow.on_resize do |x, y|
      @testwindow.size = [x, y]
      @testwindow.contents = Bitmap.new(@testwindow.width - 16, @testwindow.height - 16)
      @testwindow.draw
    end

    @testwindow.on_draw :gradient, GradientInstruction.new(
      rect: Rect.new(16, 16, 100, 24),
      color1: Color.new(0, 0, 255, 255),
      color2: Color.new(255, 0, 0, 255),
    )
    @testwindow.on_draw :font, FontInstruction.new(
      name: "Cairo",
      size: 24,
      color: Color.new(255, 0, 200, 255),
    )
    @testwindow.on_draw :hello, TextInstruction.new(
      text: "Hello!",
      x: 16,
      y: 16,
    )
    @testwindow.add_widget(
      :button,
      Button.new(Rect.new(48, 64, 64, 64), :unpressed)
    )
    @testwindow.widget(:button).on_click do |state|
      @testwindow.on_draw :buttonfont, FontInstruction.new(
        name: "Cairo",
        size: 32,
        color: Color.new(255, 255, 255),
        align: 0,
      )
      if state
        @testwindow.on_draw :buttontext, TextInstruction.new(text: "Pressed!", x: 48, y: 128)
      else
        @testwindow.on_draw :buttontext, TextInstruction.new(text: "Unpressed!", x: 48, y: 128)
      end
      @testwindow.draw
    end

    @testwindow.draw

    loop do
      Graphics.update
      Input.update
      update

      break if $scene != self
    end

    dispose
    Graphics.freeze
  end

  def dispose
  end

  def update
    $system.update
    @testwindow.update
  end
end
