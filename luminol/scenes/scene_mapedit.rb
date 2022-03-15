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

    loop do
      Graphics.update
      Input.update
      update

      break if $scene != self
    end

    dispose
    Graphics.freeze
  end

  def update
    $system.update
    $cursor.update
    @toolbar.update
  end
end
