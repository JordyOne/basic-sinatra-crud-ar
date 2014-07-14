require "sinatra"
require "active_record"
require "gschool_database_connection"
require "rack-flash"

class App < Sinatra::Application
  enable :sessions
  use Rack::Flash

  def initialize
    super
    @database_connection = GschoolDatabaseConnection::DatabaseConnection.establish(ENV["RACK_ENV"])

  end

  get "/" do


    if session[:id]
      erb :logged_in, locals: {:username => current_user_name}
    else
      erb :homepage
    end
  end

  post "/" do
    @database_connection.sql("INSERT INTO users (username, password) VALUES ('#{params[:username]}', '#{params[:password]}');")
    id_hash= (@database_connection.sql("SELECT id FROM users WHERE username = '#{params[:username]}' AND password = '#{params[:password]}'"))
    session[:id] = id_hash.first.fetch("id")
    redirect "/"
  end

  get "/registration/new" do
    erb :"registration/new"
  end

  post "/registration/" do
    flash[:notice] = "Thank you for registering"

    redirect "/"
  end

  post "/logout" do
    session.clear
    flash[:notice] = "Thank you! Come again!"
    redirect "/"

  end

  private

  def current_user_name


    @database_connection.sql("SELECT username from users where id = '#{session[:id]}'").first.fetch('username')

  end


end
