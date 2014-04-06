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

  post '/instructor/reset' do
    sessions_repository.delete_all
    ''
  end

  get "/student" do
    session[:uuid] = SecureRandom.uuid unless session[:uuid]
    sessions_repository.save(session[:uuid])
    haml :student
  end

  post "/student/you-lost-me" do
    session[:uuid] = SecureRandom.uuid unless session[:uuid]
    sessions_repository.save(session[:uuid], status: 'behind')
    ''
  end

  post "/student/caught-up" do
    session[:uuid] = SecureRandom.uuid unless session[:uuid]
    sessions_repository.save(session[:uuid], status: 'caught-up')
    ''
  end

  private

  def sessions_repository
    self.class.sessions_repository
  end

end