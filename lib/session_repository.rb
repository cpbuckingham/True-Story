Sequel.database_timezone = :utc

class SessionRepository

  attr_reader :table
  private :table

  def initialize(db)
    @table = db[:sessions]
  end

  def find(uuid)
    table[uuid: uuid]
  end

  def touch(uuid)
    row = table[uuid: uuid]
    if row
      table.where(uuid: uuid).update(updated_at: Time.now)
    else
      table.insert(uuid: uuid, updated_at: Time.now, status: 'connected')
    end
  end

  def active_sessions(time = Time.now.utc)
    table.where('updated_at > ?', time - (60 * 25)).to_a.sort_by do |session|
      session[:uuid].downcase
    end
  end

end