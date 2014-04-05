require 'spec_helper'
require 'session_repository'

describe SessionRepository do

  before do
    DB[:sessions].delete
  end

  describe "#touch" do
    it "creates a session row if one does not exist already" do
      uuid = SecureRandom.uuid
      repository = SessionRepository.new(DB)
      fixed_time = Time.now
      Time.stub(:now).and_return(fixed_time)

      expect { repository.touch(uuid) }.to change { repository.active_sessions.count }.by(1)

      active_session = repository.active_sessions.first
      expect(active_session[:uuid]).to eq(uuid)
      expect(active_session[:updated_at]).to eq(fixed_time.utc)
    end

    it "updates the existing row if one exists" do
      uuid = SecureRandom.uuid
      repository = SessionRepository.new(DB)
      fixed_time = Time.now

      Time.stub(:now).and_return(fixed_time - 10)
      repository.touch(uuid)
      active_session = repository.find(uuid)
      expect(active_session[:updated_at].to_i).to eq((fixed_time - 10).utc.to_i)

      Time.stub(:now).and_return(fixed_time)
      expect { repository.touch(uuid) }.to_not change { repository.active_sessions.count }
      active_session = repository.find(uuid)
      expect(active_session[:updated_at].to_i).to eq(fixed_time.utc.to_i)
    end
  end

end