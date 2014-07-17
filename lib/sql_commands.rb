require "gschool_database_connection"


class SqlCommands
  def initialize
    @database_connection = GschoolDatabaseConnection::DatabaseConnection.establish(ENV["RACK_ENV"])
  end

  def current_username(username)
    @database_connection.sql("SELECT username from users where username = '#{username}'")
  end

  def username_from_id(session_id)
    @database_connection.sql("SELECT username from users where id = '#{session_id}'")
  end

  def password_verification(username, password)
    @database_connection.sql("SELECT username, password from users where username = '#{username}' AND password <> '#{password}'")
  end

  def list_usernames
    @database_connection.sql("SELECT username from users")
  end

  def insert_user_and_pass(username, password)
    @database_connection.sql("INSERT INTO users (username, password) VALUES ('#{username}', '#{password}');")
  end

  def current_user_id(username, password)
    @database_connection.sql("SELECT id FROM users WHERE username = '#{username}' AND password = '#{password}'")
  end

  def delete_username(username)
    @database_connection.sql("DELETE from users where username = '#{username}'")
  end
end
