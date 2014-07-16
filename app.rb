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
      erb :logged_in, locals: {:username => current_user_name, :list_usernames => list_usernames}
    else
      erb :homepage
    end
  end

  post "/" do
    login_authentication
    session_set
    redirect "/"
  end

  get "/registration/new" do
    erb :"registration/new"
  end

  post "/registration/" do
    if params[:username] == '' || params[:password] == ''
      flash[:error] = "Please fill in all fields"
      redirect "/registration/new"
    elsif @database_connection.sql("SELECT username from users where username = '#{params[:username]}'") != []
      flash[:notice] = "That username is already taken"
      redirect "/registration/new"
    else
      @database_connection.sql("INSERT INTO users (username, password) VALUES ('#{params[:username]}', '#{params[:password]}');")
      flash[:notice] = "Thank you for registering"
      redirect "/"
    end
  end

  post "/logout" do
    session.clear
    flash[:notice] = "Thank you! Come again!"
    redirect "/"

  end

  private

  def list_usernames
    @database_connection.sql("SELECT username from users")
  end

  def current_user_name
    # if session[:id]
    @database_connection.sql("SELECT username from users where id = '#{session[:id]}'").first.fetch('username')
  end

  def login_authentication
    if params[:username] == '' || params[:password] == ''
      flash[:error] = "Please fill in all fields"
      redirect back
    elsif @database_connection.sql("SELECT username from users where username = '#{params[:username]}'") == []
      flash[:notice] = "That username doesn't exist"
      redirect back
    elsif @database_connection.sql("SELECT username, password from users where username = '#{params[:username]}' AND password <> '#{params[:password]}'") != []
      flash[:notice] = "Incorrect Password"
      redirect "/"
    end
  end

  def session_set
    session[:id] = @database_connection.sql("SELECT id FROM users WHERE username = '#{params[:username]}' AND password = '#{params[:password]}'").first.fetch("id")
    end
end

