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
      "room_1" => SessionRepo.new(pubsub, "room_1"),
      "room_2" => SessionRepo.new(pubsub, "room_2"),
      "room_3" => SessionRepo.new(pubsub, "room_3"),
      "room_4" => SessionRepo.new(pubsub, "room_4"),
      "room_5" => SessionRepo.new(pubsub, "room_5")
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
    haml :scrum_master
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
    haml :scrum_member, locals: {status: sessions_repo.find(session[:uuid])[:status], comment: sessions_repo.find(session[:uuid])[:comment]}
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

  post "/:location/team_member" do
    session[:uuid] = SecureRandom.uuid unless session[:uuid]
    sessions_repo.update_comment(session[:uuid], params[:comment])
    redirect "/#{params[:location]}/team_member"
  end


  private

  attr_reader :sessions_repos

  def sessions_repo
    sessions_repos[params[:location]]
  end

end
