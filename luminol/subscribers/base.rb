class BaseSignal
  def initialize
    @subscribers = []
  end

  def on_call(&subscriber)
    @subscribers << subscriber
    return @subscribers.length - 1
  end

  def <<(subscriber)
    @subscribers << subscriber
    return @subscribers.length - 1
  end

  def pop
    return @subscribers.pop
  end

  def >>(subscriber)
    return @subscribers.delete_at(subscriber)
  end

  def notify(*args)
    @subscribers.each do |subscriber|
      subscriber.call(*args)
    end
  end

  def index(subscriber)
    return @subscribers.index(subscriber)
  end
end
