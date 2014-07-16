require "sinatra"
require "active_record"
require "rack-flash"
require_relative "lib/sql_commands"

class App < Sinatra::Application
  enable :sessions
  use Rack::Flash

  def initialize
    super
    @sql = SqlCommands.new


  end

  get "/" do
    if session[:id]
      erb :logged_in, locals: {:username => current_user_name, :list_usernames => @sql.list_usernames}
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
    elsif @sql.current_username(params[:username]) != []
      flash[:notice] = "That username is already taken"
      redirect "/registration/new"
    else
      @sql.insert_user_and_pass(params[:username], params[:password])
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

  def current_user_name
    @sql.username_from_id(session[:id]).first.fetch('username')
  end

  def login_authentication
    if params[:username] == '' || params[:password] == ''
      flash[:error] = "Please fill in all fields"
      redirect back
    elsif @sql.current_username(params[:username]) == []
      flash[:notice] = "That username doesn't exist"
      redirect back
    elsif @sql.password_verification(params[:username], params[:password]) != []
      flash[:notice] = "Incorrect Password"
      redirect "/"
    end
  end

  def session_set
    session[:id] = @sql.current_user_id(params[:username], params[:password]).first.fetch("id")
    end
end

