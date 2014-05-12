class PubSub
  def initialize
    Pusher.url =  "http://#{ENV["PUSHER_KEY"]}:#{ENV["PUSHER_SECRET"]}@api.pusherapp.com/apps/#{ENV["PUSHER_APP"]}"
  end

  def publish(channel, event, data)
    Pusher[channel].trigger(event, data)
  end
end