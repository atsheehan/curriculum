require "sinatra"

get "/tasks" do
  tasks = ["pay bills", "buy milk", "learn Ruby"]
  erb :index, locals: { tasks: tasks }
end

get "/tasks/:task_name" do
  erb :show, locals: { task_name: params[:task_name] }
end

# These lines can be removed since they are using the default values. They've
# been included to explicitly show the configuration options.
set :views, File.join(File.dirname(__FILE__), "/views")
set :public_folder, File.join(File.dirname(__FILE__), "/public")
