class Scene_MapEdit
  def main
    # Setup Scene
    Graphics.transition(40)
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
  end
end
