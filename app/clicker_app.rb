require 'sinatra/base'
require_relative '../lib/session_repository'
require 'sinatra/content_for'
require "sinatra/json"
require "haml"

class ClickerApp < Sinatra::Application

  helpers Sinatra::ContentFor
  helpers Sinatra::JSON

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

  get '/instructor.json' do
    active_sessions = sessions_repository.active_sessions
    json active_sessions.map { |session| { id: session[:uuid], status: session[:status] } }
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