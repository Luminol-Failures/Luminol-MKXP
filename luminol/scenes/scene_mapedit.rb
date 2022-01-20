require_relative "../window_base/window_base"

class Scene_MapEdit
  def main
    # Setup Scene
    Graphics.transition(40)

    @testwindow = Window_Base.new(0, 0, 640, 480)
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
  end
end
