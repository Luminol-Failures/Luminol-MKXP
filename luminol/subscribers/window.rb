require_relative "base"

class WindowSignal < BaseSignal
  def notify_change(window)
    notify(window)
  end

  def notify(window)
    @subscribers.each do |subscriber|
      subscriber.call(window)
    end
  end
end
