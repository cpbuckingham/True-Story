require "spec_helper"

describe SessionRepo do
  let(:pubsub) { double(PubSub, publish: nil) }
  let(:storage) { {} }
  let(:session_repo) { SessionRepo.new(pubsub, storage) }

  describe "#join" do
    it "adds a session to storage with the correct attributes" do
      session_repo.join("1234")

      expect(storage.length).to eq(1)
      expect(storage["1234"][:uuid]).to eq("1234")
      expect(storage["1234"][:status]).to eq(SessionRepo::UNKNOWN)
    end

    it "notifies pubsub of a touch event" do
      session_repo.join("1234")

      expect(pubsub).to have_received(:publish).with("default",
                                                     "update",
                                                     {
                                                       uuid: "1234",
                                                       status: SessionRepo::UNKNOWN
                                                     })
    end
  end

  describe "#update_status" do
    it "updates the session with the correct status" do
      session_repo.join("1234")
      session_repo.update_status("1234", SessionRepo::BEHIND)

      expect(session_repo.find("1234")[:status]).to eq(SessionRepo::BEHIND)
    end

    it "creates a session if it doesn't exist" do
      session_repo.update_status("1234", SessionRepo::BEHIND)
      expect(session_repo.find("1234")[:status]).to eq(SessionRepo::BEHIND)
    end

    it "publishes an update event to the pubsub" do
      session_repo.update_status("1234", SessionRepo::BEHIND)

      expect(pubsub).to have_received(:publish).with("default",
                                                     "update",
                                                     {
                                                       uuid: "1234",
                                                       status: SessionRepo::BEHIND
                                                     })
    end
  end

  describe "#find" do
    it "finds a user by their uuid" do
      storage["some uuid"] = {uuid: "some uuid", status: "some status"}
      storage["another uuid"] = {uuid: "another uuid", status: "another status"}

      session = session_repo.find("some uuid")
      expect(session).to eq(uuid: "some uuid", status: "some status")
    end
  end

  describe "#active_sessions" do
    it "returns all active_sessions" do
      storage["some uuid"] = {uuid: "some uuid", status: "some status"}
      storage["another uuid"] = {uuid: "another uuid", status: "another status"}

      sessions = session_repo.active_sessions

      expect(sessions.length).to eq(2)
    end
  end

  describe "#delete_all" do
    it "removes everything from storage" do
      storage["some uuid"] = {uuid: "some uuid", status: "some status"}
      storage["another uuid"] = {uuid: "another uuid", status: "another status"}

      session_repo.delete_all

      expect(storage).to be_empty
    end

    it "publishes a delete_all event" do
      session_repo.delete_all

      expect(pubsub).to have_received(:publish).with("default", "delete_all", {})
    end
  end
end