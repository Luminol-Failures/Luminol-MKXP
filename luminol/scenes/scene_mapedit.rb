require_relative "../window_base/window_base"

class Scene_MapEdit
  def main
    # Setup Scene
    Graphics.transition(40)

    @testwindow = Window_Base.new(0, 0, 640, 480)

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
