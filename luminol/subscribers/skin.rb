require_relative "base"

module SkinSignal
  include Signal_Base

  def self.notify_change(skin)
    notify(skin)
  end
end
