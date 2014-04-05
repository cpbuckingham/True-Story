require 'sinatra/base'

class ClickerApp < Sinatra::Application

  get "/" do
    haml :index
  end

  get "/instructor" do
    haml :instructor
  end

  get "/student" do
    haml :student
  end

end