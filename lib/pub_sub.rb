class PubSub
  def initialize
    Pusher.url = "http://ad19028119cbf87369e4:491d4c83af1dc4cb96eb@api.pusherapp.com/apps/136577"
  end

  def publish(channel, event, data)
    Pusher[channel].trigger(event, data)
  end
end
