class BaseSignal
  @@subscribers = []

  def self.on_call(&subscriber)
    @@subscribers << subscriber
    return @@subscribers.length - 1
  end

  def self.<<(subscriber)
    @@subscribers << subscriber
    return @@subscribers.length - 1
  end

  def self.pop
    return @@subscribers.pop
  end

  def self.>>(subscriber)
    return @@subscribers.delete_at(subscriber)
  end

  def self.notify(*args)
    @@subscribers.each do |subscriber|
      subscriber.call(args)
    end
  end
end
