require 'sinatra/base'
require_relative '../lib/session_repository'

class ClickerApp < Sinatra::Application

  class << self
    attr_accessor :sessions_repository
  end

  enable :sessions

  get "/" do
    haml :index
  end

  get "/instructor" do
    active_sessions = sessions_repository.active_sessions
    haml :instructor, locals: { active_sessions: active_sessions.count }
  end

  get "/student" do
    session[:uuid] = SecureRandom.uuid unless session[:uuid]
    sessions_repository.touch(session[:uuid])
    haml :student
  end

  private

  def sessions_repository
    self.class.sessions_repository
  end

end