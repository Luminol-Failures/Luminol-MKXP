require_relative "base"

class ResizeSignal < BaseSignal
  @@width = Graphics.width
  @@height = Graphics.height

  def self.update
    if Graphics.width != @@width || Graphics.height != @@height
      @@width = Graphics.width
      @@height = Graphics.height
      notify(@@width, @@height)
    end
  end
end
