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

  def delete_all
    table.delete
  end

  def save(uuid, status: 'connected')
    row = table[uuid: uuid]
    if row
      table.where(uuid: uuid).update(updated_at: Time.now, status: status)
    else
      table.insert(uuid: uuid, updated_at: Time.now, status: status)
    end
  end

  def active_sessions(time = Time.now.utc)
    table.where('updated_at > ?', time - (60 * 25)).to_a.sort_by do |session|
      session[:uuid].downcase
    end
  end

end