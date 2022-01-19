require_relative "base"

class SkinSignal < BaseSignal
  def self.notify_change(skin)
    self.notify(skin)
  end

  def update
  end
end
