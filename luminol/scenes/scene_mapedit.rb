require_relative "../window_base/window_selectable"
require_relative "../window_base/widgets/button"

class Scene_MapEdit
  def main
    # Setup Scene
    Graphics.transition(40)

    @testwindow = Window_Selectable.new(0, 0, 640, 480)
    @testwindow.contents = Bitmap.new(@testwindow.width - 16, @testwindow.height - 16)
    @testwindow.on_resize do |x, y|
      @testwindow.width = x
      @testwindow.height = y
      @testwindow.contents = Bitmap.new(@testwindow.width - 16, @testwindow.height - 16)
      @testwindow.draw
    end

    @testwindow.on_draw "gradient", :gradient, rect: Rect.new(16, 16, 100, 24), color1: Color.new(0, 0, 255, 255), color2: Color.new(255, 0, 0, 255)
    @testwindow.on_draw "font", :font, name: "Cairo", size: 24, color: Color.new(255, 0, 200, 255)
    @testwindow.on_draw "text", :hello, text: "Hello!", x: 16, y: 16
    @testwindow.add_widget(
      :button,
      Button.new(Rect.new(48, 64, 64, 64), :unpressed)
    )
    @testwindow.widget(:button).on_click do |state|
      @testwindow.on_draw "font", :buttonfont, name: "Cairo", size: 32, color: Color.new(255, 255, 255), align: 0
      if state
        @testwindow.on_draw "text", :buttontext, text: "Pressed!", x: 48, y: 128
      else
        @testwindow.on_draw "text", :buttontext, text: "Unpressed!", x: 48, y: 128
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
