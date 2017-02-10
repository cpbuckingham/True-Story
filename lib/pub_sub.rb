class PubSub
  def initialize
    Pusher.url = ENV['PUSHER_KEY']
  end

  def publish(channel, event, data)
    Pusher[channel].trigger(event, data)
  end
end
