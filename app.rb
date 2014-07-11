require "sinatra"
require "active_record"
require "./lib/database_connection"
require "rack-flash"

class App < Sinatra::Application
  enable :sessions
  use Rack::Flash

  def initialize
    super
    @database_connection = DatabaseConnection.establish(ENV["RACK_ENV"])

  end

  get "/" do
    erb :homepage
  end

  post "/" do
    @database_connection.sql("INSERT INTO users (username) VALUES ('#{params[:username]}');")
  redirect "/"
  end

  get "/registration/new" do
    erb :"registration/new"
  end

  post "/registration/" do
    flash[:notice] = "Thank you for registering"

    redirect "/"
  end
end
