require_relative "../windows/window_toolbar"

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

  def dispose
  end

  def update
    $system.update
    $cursor.update
    @toolbar.update
  end
end
