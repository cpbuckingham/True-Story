require 'sinatra/base'
require_relative '../lib/session_repo'
require 'sinatra/content_for'
require "sinatra/json"
require "haml"

class ClickerApp < Sinatra::Application
  helpers Sinatra::ContentFor
  helpers Sinatra::JSON

  class << self
    attr_accessor :sessions_repo
  end

  enable :sessions

  get "/" do
    haml :index
  end

  get "/instructor" do
    haml :instructor
  end

  get '/instructor.json' do
    active_sessions = sessions_repo.active_sessions
    json(active_sessions)
  end

  post '/instructor/reset' do
    sessions_repo.delete_all
    ''
  end

  get "/student" do
    session[:uuid] = SecureRandom.uuid unless session[:uuid]
    sessions_repo.join(session[:uuid])
    haml :student, locals: {status: sessions_repo.find(session[:uuid])[:status]}
  end

  post "/student/you-lost-me" do
    session[:uuid] = SecureRandom.uuid unless session[:uuid]
    sessions_repo.update_status(session[:uuid], SessionRepo::BEHIND)
    ''
  end

  post "/student/caught-up" do
    session[:uuid] = SecureRandom.uuid unless session[:uuid]
    sessions_repo.update_status(session[:uuid], SessionRepo::CAUGHT_UP)
    ''
  end

  private

  def sessions_repo
    self.class.sessions_repo
  end

end