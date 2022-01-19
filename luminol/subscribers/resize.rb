require_relative "base"

class ResizeSignal < BaseSignal
  @@width = Graphics.window_width
  @@height = Graphics.window_height

  def self.update
    if Graphics.window_width != @@width || Graphics.window_height != @@height
      @@width = Graphics.window_width
      @@height = Graphics.window_height
      Graphics.resize_screen(@@width, @@height)
      self.notify(@@width, @@height)
    end
  end
end
