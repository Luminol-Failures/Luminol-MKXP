require_relative '../windows/window_toolbar'
require_relative '../window_base/window_draggable'
require_relative '../window_base/widgets/page'
require_relative '../window_base/widgets/filepicker'
require_relative '../window_base/widgets/list'

class Scene_MapEdit
  def main
    # Setup Scene
    Graphics.transition(40)

    @toolbar = Window_ToolBar.new
    @toolbar.draw

    @test_window = Window_Draggable.new(50, 50, 100, 100)
    @page = Page.new(Rect.new(0, 0, 80, 80))
    @picker = Filepicker.new(Rect.new(0, 0, 80, 80))
    @page.add_widget(@picker, 'File picker')
    @items = []
    @list = List.new(Rect.new(0, 0, 80, 80), @items)
    @page.add_widget(@list, 'List test')

    @test_window.add_widget(:page, @page)

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
