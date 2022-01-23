require_relative "base"

class SkinSignal < BaseSignal
  def notify_change(skin)
    notify(skin)
  end

  def update
  end
end
