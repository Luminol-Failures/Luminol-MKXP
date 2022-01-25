require_relative "../window_base/window_draggable"
require_relative "../window_base/draw_types/draw_types"
require_relative "../window_base/widgets/list"
require_relative "../window_base/widgets/scroller"
require_relative "../window_base/widgets/textinput"

class Scene_MapEdit
  def main
    # Setup Scene
    Graphics.transition(40)

    # Grab icon
    icon = Bitmap.new(16, 16)
    skin = $system.skin
    icon.blt(0, 0, skin, Rect.new(192, 80, 16, 16))

    @testwindow = Window_Draggable.new(0, 0, 240, 480, "Sound Test", icon)
    @testwindow.contents = Bitmap.new(@testwindow.width - 32, @testwindow.height - 32)

    items = ["this is a list", "it can draw text in a list!", "but only text.", "it has any arbitrary size", "so make sure to use a scroller!"]
    @list = List.new(Rect.new(0, 0, 0, 0), items)
    @list.on_select do |index|
      print "selected #{index}!\n"
    end

    @scroller = Scroller.new(Rect.new(0, 0, 200, 200))
    @scroller.add_widget(@list)
    @testwindow.add_widget(:scrollerlist, @scroller)

    @textinput = TextInput.new(Rect.new(0, 0, 200, 480), hint_text: "Hint text here...")
    @textinput.on_finish do |text|
      print "Text: #{text}"
    end
    @scroller2 = Scroller.new(Rect.new(0, 216, 200, 200))
    @scroller2.add_widget(@textinput)
    @testwindow.add_widget(:scrollerlist2, @scroller2)

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
    $cursor.update

    @testwindow.update
  end
end
