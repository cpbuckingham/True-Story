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
      "boulder" => SessionRepo.new(pubsub, "boulder"),
      "denver" => SessionRepo.new(pubsub, "denver"),
      "sf" => SessionRepo.new(pubsub, "sf")
    }
  end

  enable :sessions

  get "/" do
    haml :index
  end
  
  get "/:location" do
    haml :select_role
  end

  get "/:location/instructor" do
    haml :instructor
  end

  get "/:location/instructor.json" do
    active_sessions = sessions_repo.active_sessions
    json(active_sessions)
  end

  post "/:location/instructor/reset" do
    sessions_repo.delete_all
    ""
  end

  get "/:location/student" do
    session[:uuid] = SecureRandom.uuid unless session[:uuid]
    sessions_repo.join(session[:uuid])
    haml :student, locals: {status: sessions_repo.find(session[:uuid])[:status]}
  end

  post "/:location/student/you-lost-me" do
    session[:uuid] = SecureRandom.uuid unless session[:uuid]
    sessions_repo.update_status(session[:uuid], SessionRepo::BEHIND)
    ""
  end

  post "/:location/student/caught-up" do
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