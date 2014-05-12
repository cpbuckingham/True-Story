class SessionRepo
  BEHIND = "behind"
  CAUGHT_UP = "caught-up"
  UNKNOWN = "connected"

  def initialize(pubsub, storage = {})
    @pubsub = pubsub
    @storage = storage
  end

  def join(uuid)
    update_status(uuid, UNKNOWN)
  end

  def update_status(uuid, status)
    session = find(uuid) || new_session(uuid)
    session[:status] = status

    pubsub.publish("default", "update", session)
  end

  def find(uuid)
    storage[uuid]
  end

  def active_sessions
    storage.dup
  end

  def delete_all
    storage.clear
    pubsub.publish("default", "delete_all", {})
  end

  private

  def new_session(uuid)
    storage[uuid] = {uuid: uuid, status: UNKNOWN}
  end

  attr_reader :pubsub, :storage
end