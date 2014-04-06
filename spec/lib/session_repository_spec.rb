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

      repository.save(uuid)
      repository.delete_all

      expect(repository.active_sessions.count).to eq(0)
    end
  end

  describe "#save" do
    it "creates a session row if one does not exist already" do
      uuid = SecureRandom.uuid
      repository = SessionRepository.new(DB)
      fixed_time = Time.now
      Time.stub(:now).and_return(fixed_time)

      expect { repository.save(uuid) }.to change { repository.active_sessions.count }.by(1)

      active_session = repository.active_sessions.first
      expect(active_session[:uuid]).to eq(uuid)
      expect(active_session[:updated_at]).to eq(fixed_time.utc)
      expect(active_session[:status]).to eq('connected')
    end

    it "sets the status to the one passed in when creating a new session" do
      uuid = SecureRandom.uuid
      repository = SessionRepository.new(DB)

      expect { repository.save(uuid, status: 'behind') }.to change { repository.active_sessions.count }.by(1)

      active_session = repository.active_sessions.first
      expect(active_session[:status]).to eq('behind')
    end

    it "updates the existing row if one exists" do
      uuid = SecureRandom.uuid
      repository = SessionRepository.new(DB)
      fixed_time = Time.now

      Time.stub(:now).and_return(fixed_time - 10)
      repository.save(uuid)
      active_session = repository.find(uuid)
      expect(active_session[:updated_at].to_i).to eq((fixed_time - 10).utc.to_i)

      Time.stub(:now).and_return(fixed_time)
      expect { repository.save(uuid) }.to_not change { repository.active_sessions.count }
      active_session = repository.find(uuid)
      expect(active_session[:updated_at].to_i).to eq(fixed_time.utc.to_i)
    end

    it "updates the existing row with the given status" do
      uuid = SecureRandom.uuid
      repository = SessionRepository.new(DB)
      repository.save(uuid)

      repository.save(uuid, status: 'behind')
      active_session = repository.find(uuid)
      expect(active_session[:status]).to eq('behind')
    end
  end

end