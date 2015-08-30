require "sinatra/base"
require_relative "../lib/session_repo"
require "sinatra/content_for"
require "sinatra/json"
require "haml"

class ClickerApp < Sinatra::Application
  helpers Sinatra::ContentFor
  helpers Sinatra::JSON

  def initialize(*_)
    super

    pubsub = PubSub.new
    @sessions_repos = {
      "rc_starters" => SessionRepo.new(pubsub, "rc_starters"),
      "rc_fullfillers" => SessionRepo.new(pubsub, "rc_fullfillers"),
      "rc_dashers" => SessionRepo.new(pubsub, "rc_dashers"),
      "rc_embarcers" => SessionRepo.new(pubsub, "rc_embarcers"),
      "innovation_friday" => SessionRepo.new(pubsub, "innovation_friday")
    }
  end

  enable :sessions

  get "/" do
    haml :index
  end

  get "/:location" do
    haml :select_role
  end

  get "/:location/scrum_master" do
    haml:instructor
  end

  get "/:location/scrum_master.json" do
    active_sessions = sessions_repo.active_sessions
    json(active_sessions)
  end

  post "/:location/scrum_master/reset" do
    sessions_repo.delete_all
    ""
  end

  get "/:location/team_member" do
    session[:uuid] = SecureRandom.uuid unless session[:uuid]
    sessions_repo.join(session[:uuid])
    haml :student, locals: {status: sessions_repo.find(session[:uuid])[:status]}
  end

  post "/:location/team_member/you-lost-me" do
    session[:uuid] = SecureRandom.uuid unless session[:uuid]
    sessions_repo.update_status(session[:uuid], SessionRepo::BEHIND)
    ""
  end

  post "/:location/team_member/caught-up" do
    session[:uuid] = SecureRandom.uuid unless session[:uuid]
    sessions_repo.update_status(session[:uuid], SessionRepo::CAUGHT_UP)
    ""
  end



  private

  attr_reader :sessions_repos

  def sessions_repo
    sessions_repos[params[:location]]
  end

end
