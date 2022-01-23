require_relative "../window_base/window_selectable"
require_relative "../window_base/draw_types/draw_types"
require_relative "../window_base/widgets/button"
require_relative "../window_base/widgets/radio_button"

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
      Button.new(Rect.new(48, 64, 64, 64), :normal)
    )
    button_proc = proc do |state|
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
    @testwindow.widget(:button).on_click(&button_proc)

    # We can take advantage of the fact that adding an element to an array will not make a new object
    radio_array = []
    radio_array << RadioButton.new(Rect.new(48, 180, 64, 64), pressed: true, siblings: radio_array)
    radio_array << RadioButton.new(Rect.new(128, 180, 64, 64), siblings: radio_array)
    radio_array << RadioButton.new(Rect.new(208, 180, 64, 64), siblings: radio_array)
    radio_array << RadioButton.new(Rect.new(288, 180, 64, 64), siblings: radio_array)
    radio_proc = proc do |id|
      @testwindow.on_draw :radiofont, FontInstruction.new(
        name: "Terminus (TTF)",
        size: 32,
        color: Color.new(255, 255, 255),
        align: 0,
      )

      @testwindow.on_draw :radiotext, TextInstruction.new(text: "Radio #{id} pressed", x: 48, y: 250)
      @testwindow.draw
    end
    radio_array.each { |radio| radio.on_click(&radio_proc) }
    radio_proc.call(0)

    radio_array.each_with_index { |r, i| @testwindow.add_widget(eval(":radio_#{i}"), r) }

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
