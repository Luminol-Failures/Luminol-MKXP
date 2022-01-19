require_relative "base"

class SkinSignal < BaseSignal
  def self.notify_change(skin)
    notify(skin)
  end

  def update
  end
end
