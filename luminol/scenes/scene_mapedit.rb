require_relative '../windows/window_toolbar'
require_relative '../window_base/window_draggable'
require_relative '../window_base/widgets/page'
require_relative '../window_base/widgets/filepicker'
require_relative '../window_base/widgets/list'
require_relative '../window_base/widgets/textinput'

class Scene_MapEdit
  def main
    # Setup Scene
    Graphics.transition(40)

    @toolbar = Window_ToolBar.new
    @toolbar.draw

    @test_window = Window_Draggable.new(50, 50, 256, 256, 'Page test')
    @page = Page.new(Rect.new(0, 0, 200, 200))
    @picker = Filepicker.new(Rect.new(0, 0, 100, 100))
    @page.add_widget(@picker, 'File picker')
    @items = Dir.children('.')
    @list = List.new(Rect.new(0, 0, 100, 100), items: @items)
    @page.add_widget(@list, 'List test')
    @textinput = TextInput.new(Rect.new(0, 0, 100, 100))
    @page.add_widget(@textinput, 'Text')

    @test_window.add_widget(:page, @page)
    @test_window.draw

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
    @toolbar.update

    @test_window.update
  end
end
