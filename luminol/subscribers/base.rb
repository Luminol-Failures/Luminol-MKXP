module Signal_Base
  @subscribers = []

  def self.<<(subscriber)
    @subscribers << subscriber
  end

  def self.pop
    return @subscribers.pop
  end

  def self.>>(subscriber)
    return @subscribers.delete_at(subscriber)
  end

  def notify(event)
    @subscribers.each do |subscriber|
      subscriber.notify(event)
    end
  end
end
