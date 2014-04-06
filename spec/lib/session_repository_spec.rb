require 'spec_helper'
require 'session_repository'

describe SessionRepository do

  before do
    DB[:sessions].delete
  end

  describe "#delete_all" do
    it "deletes all rows" do
      uuid = SecureRandom.uuid
      repository = SessionRepository.new(DB)

      repository.touch(uuid)
      repository.delete_all

      expect(repository.active_sessions.count).to eq(0)
    end
  end

  describe "#update" do
    it "updates the existing row with the current time and the given status" do
      uuid = SecureRandom.uuid
      repository = SessionRepository.new(DB)
      fixed_time = Time.now

      Time.stub(:now).and_return(fixed_time - 10)
      repository.touch(uuid)
      active_session = repository.find(uuid)
      expect(active_session[:updated_at].to_i).to eq((fixed_time - 10).utc.to_i)

      Time.stub(:now).and_return(fixed_time)
      expect { repository.update(uuid, status: SessionRepository::BEHIND) }.to_not change { repository.active_sessions.count }
      active_session = repository.find(uuid)
      expect(active_session[:updated_at].to_i).to eq(fixed_time.utc.to_i)
      expect(active_session[:status]).to eq(SessionRepository::BEHIND)
    end
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
      expect(active_session[:status]).to eq(SessionRepository::CONNECTED)
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