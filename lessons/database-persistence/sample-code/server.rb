require "sinatra"
require "pg"

def db_connection
  begin
    connection = PG.connect(dbname: "todo")
    yield(connection)
  ensure
    connection.close
  end
end

get "/tasks" do
  tasks = db_connection { |conn| conn.exec("SELECT name FROM tasks") }
  erb :index, locals: { tasks: tasks }
end

get "/tasks/:task_name" do
  erb :show, locals: { task_name: params[:task_name] }
end

post "/tasks" do
  # Read the input from the form the user filled out
  task = params["task_name"]

  # Insert new task into the database
  db_connection do |conn|
    conn.exec_params("INSERT INTO tasks (name) VALUES ($1)", [task])
  end

  # Send the user back to the home page which shows
  # the list of tasks
  redirect "/tasks"
end

# These lines can be removed since they are using the default values. They've
# been included to explicitly show the configuration options.
set :views, File.join(File.dirname(__FILE__), "views")
set :public_folder, File.join(File.dirname(__FILE__), "public")
