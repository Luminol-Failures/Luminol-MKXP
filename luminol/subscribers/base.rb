class BaseSignal
  @@subscribers = []

  def self.<<(subscriber)
    @@subscribers << subscriber
  end

  def self.pop
    return @@subscribers.pop
  end

  def self.>>(subscriber)
    return @@subscribers.delete_at(subscriber)
  end

  def notify(*args)
    @@subscribers.each do |subscriber|
      subscriber.notify(args)
    end
  end
end
