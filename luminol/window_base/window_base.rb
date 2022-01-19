require_relative "../subscribers/skin"
require_relative "../subscribers/resize"

class Window_Base < Window
  def initialize(x, y, width, height)
    super()
    self.windowskin = $system.windowskin
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    SkinSignal << (Proc.new do |skin|
      self.windowskin = $system.windowskin
    end)
  end

  def on_resize(&block)
    ResizeSignal << block
  end

  def update
    super
  end
end
