To make a interactive web applications users often need a way to submit information back to the server. In this article we'll discuss how HTTP POST requests can be used to submit user input entered via HTML forms.

### Learning Goals

* Add an HTML form to a web page.
* Pass user input to the web server via an HTTP POST request.
* Persist user input using the filesystem.

### HTML Forms

In the [Dynamic Web Pages article](/lessons/dynamic-web-pages) we built a TODO application that rendered a list of tasks from an array (sample code can be found [here][todo-sample-code]). In this article we'll revisit the application by adding a feature that allows users to submit a new task and save it so that it appears on the list when the page refreshes. To do this we'll need to make two changes to our application: modify the HTML to include a form for submitting the task and update the server to save the incoming tasks to a file.

HTML forms are the conventional way for a user to submit information to a website. Forms allow for a variety of different inputs: typing in a text field, selecting options from a drop-down list, attaching a file for upload, etc. When a user is finished filling out a form, they can click a button to *submit* the form back to a web server along with all of their input.

To add a form to a web page we use the `<form>` element. Within the form we can define all of our inputs (e.g. text fields, select lists, etc.) but we also need to specify what happens when a user submits their info. Submitting a form is similar to clicking on a link in that it sends an HTTP request back to the server. The primary difference is that with a form we have the option to send an HTTP POST request rather than an HTTP GET. GET requests are intended for viewing web pages whereas POST requests are used when we want to modify or update something in our web app. Since we want to add a new task to our app a POST request would be more appropriate here.

Every HTTP request has both a method and a path. Since we're creating a new task we can re-use the `/tasks` path but we'll change our method to POST. Note that `POST /tasks` performs a different function than `GET /tasks`. They're both using the same path, but the POST is *submitting* information to be saved whereas the GET is *retrieving* existing information.

To create a form that will send a POST request to the `/tasks` path we could start with the following HTML:

```HTML
<form action="/tasks" method="post">
```

The *action* attribute specifies the path that the form submission will go to and the *method* attribute is used to choose between sending a POST request and a GET request. If our form is submitting information to be saved or otherwise change the state of our application then we should use POST: GET requests should only be used when a form does not modify or update anything on the server (e.g. using a form to search a site).

The `<form>` element by itself doesn't do much other than describe the endpoint for the request once it is submitted. To add various components we can use `<input>` elements. An input can represent a text field, a select list, checkboxes, a submit button, and many other widgets (a full list of input types can be found [here](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input#attr-type)).

For our form we'll need to add two components: a text field where the user can type in the name of the task and a button so they can submit the form:

```HTML
<form action="/tasks" method="post">
  <label for="task_name">New Task:</label>
  <input type="text" id="task_name" name="task_name">

  <input type="submit">
</form>
```

Here we've added two `<input>` elements: a text field with `type="text"` and a submit button with `type="submit"`. We've also included a `<label>` element for the text field indicating what the user should fill out. To ensure that the label is attached to the right input we match `for="task_name"` attribute on the label with `id="task_name"` on the text field.

Another important attribute is the `name="task_name"` attribute on the text field. This is used to identify what the user typed into that particular field when it is passed along to the server. If there were multiple input fields we could distinguish between them based on their name attributes.

Let's go ahead and add our form to the template file in *views/index.erb*:

```HTML
<!DOCTYPE html>
<html>
  <head>
    <title>Basic HTML Page</title>
    <link rel="stylesheet" href="/home.css">
  </head>

  <body>
    <h1>TODO list</h1>

    <ul>
      <% tasks.each do |task| %>
        <li><a href="/tasks/<%= task %>"><%= task %></a></li>
      <% end %>
    </ul>

    <form action="/tasks" method="post">
      <label for="task_name">New Task:</label>
      <input type="text" id="task_name" name="task_name">

      <input type="submit">
    </form>
  </body>
</html>
```

If we start up our server (by running `ruby server.rb`) and visit [http://localhost:4567/tasks][localhost-tasks] we should see our shiny new form:

![New Task Form](https://s3.amazonaws.com/hal-assets.launchacademy.com/http-sinatra/new_task_form.png)

After filling in the text field and hitting submit we'll be confronted with the following error:

![No Route for /tasks](https://s3.amazonaws.com/hal-assets.launchacademy.com/http-sinatra/no_route_error.png)

When the form is submitted we're sending an HTTP POST request to the `/tasks` path. This is what we want, except that we haven't defined anything in our *server.rb* file to handle this request which is why Sinatra is raising an error.

### HTTP POST

Before we change our *server.rb* file, let's see what a POST request looks like. When a user submits the form their browser will send something like the following:

```no-highlight
POST /tasks HTTP/1.1
Host: localhost
Content-Length: 29

task_name=take+over+the+world
```

The first line defines both the method (*POST*) and the path (`/tasks`). The main distinction between a POST and a GET request is the request body. This is where all of the user input is stored in key-value pairs:

```no-highlight
task_name=take+over+the+world
```

Since we have a text field input with an attribute `name="task_name"` the browser will take whatever the user entered in that field and form the `task_name=<user input>` pair. If the user typed "take over the world" we'll end up with the key-value pair `task_name=take+over+the+world`. Notice how the spaces have been replaced by *+* symbols; this is known as URL encoding and allows us to send special characters (such as whitespace) in the request body (you might also see *%20* as an encoding for spaces).

We also have to include the size of the HTTP request body using the *Content-Length* header so that the web server knows how much data to expect. In this case our `task_name=take+over+the+world` body is 29 characters long so we just have to specify `Content-Length: 29`.

### Updating Our Webserver

We have the form setup on the client-side, now how do we handle the incoming POST request on the server? We previously defined a block of code to handle `GET /tasks` requests using `get "/tasks"` in our *server.rb* file. We can do something similar to handle a `POST /tasks` request by adding `post "/tasks"`:

```ruby
post "/tasks" do
end
```

If we restarted our server and submitted the form again, we won't get an error anymore. Instead we'll be shown a blank page since we have an empty block of code. There are two things we want to do when we receive a `POST /tasks` request: save the new task that the user input and then redisplay the list. We'll start with the latter since we already have a way to view the tasks by visiting the home page. In this case we can just redirect to the user back to the `GET /tasks` route in our response:

```ruby
post "/tasks" do
  redirect "/tasks"
end
```

Now whenever the user submits the form they'll be redirected back to the home page.

We still have the issue of saving the task. We could append to the `tasks` array but we'll lose this information once we restart the server since it is stored in memory. A more permanent solution would be to read and write the tasks to a file:

```ruby
post "/tasks" do
  # Read the input from the form the user filled out
  task = params["task_name"]

  # Open the "tasks.txt" file and append the task
  File.open("tasks.txt", "a") do |file|
    file.puts(task)
  end

  # Send the user back to the home page which shows
  # the list of tasks
  redirect "/tasks"
end
```

Everything that the user submits through a form is accessible via the `params` hash. For our form the params hash might look something like:

```ruby
{ "task_name" => "take over the world" }
```

A great way to see this in action is to use the **pry** gem, a Ruby debugger that lets us insert breakpoints into our code and inspect any variables defined. Run the following command to install the gem:

```no-highlight
$ gem install pry
```

To load the debugger, add `require "pry"` to the top of the *server.rb* file and insert a breakpoint using `binding.pry` where you want to look around:

```ruby
require "sinatra"
require "pry"

get "/tasks" do
  tasks = ["pay bills", "buy milk", "learn Ruby"]
  erb :index, locals: { tasks: tasks }
end

get "/tasks/:task_name" do
  erb :show, locals: { task_name: params[:task_name] }
end

post "/tasks" do
  # Temporarily insert a debugger breakpoint here so
  # we can view the *params* hash.
  binding.pry

  # Read the input from the form the user filled out
  task = params["task_name"]

  # Open the "tasks" file and append the task
  File.open("tasks.txt", "a") do |file|
    file.puts(task)
  end

  # Send the user back to the home page which shows
  # the list of tasks
  redirect "/tasks"
end

# These lines can be removed since they are using the default values. They've
# been included to explicitly show the configuration options.
set :views, File.join(File.dirname(__FILE__), "views")
set :public_folder, File.join(File.dirname(__FILE__), "public")
```

Restart your server and submit a new task. You'll see in your terminal that the execution is paused:

```no-highlight
    11: end
    12:
    13: post "/tasks" do
    14:   # Temporarily insert a debugger breakpoint here so
    15:   # we can view the *params* hash.
 => 16:   binding.pry
    17:
    18:   # Read the input from the form the user filled out
    19:   task = params["task_name"]
    20:
    21:   # Open the "tasks" file and append the task

[1] pry(#<Sinatra::Application>)>
```

If you type `params` it will return the current params hash where we can see what the user submitted via the form:

```no-highlight
[1] pry(#<Sinatra::Application>)> params
=> {"task_name"=>"take over the world"}
```

The keys in the hash correspond to the names of the inputs on our form. Our text field had the attribute `name="task_name"` so when the form is submitted we can access the user's input via `params['task_name']`. Here we're saving the task in a separate variable `task = params["task_name"]` for use later.

Next we need to write this task to a file. We'll use a file named *tasks.txt* to store the list of tasks, one per line. `File.open("tasks.txt", "a")` will open the *tasks.txt* file for *appending* (using the `"a"` filemode). When opening a file for appending all changes will be written at the end of the file which is what `file.puts(task)` statement will do for us.

After you're finished looking around in *pry*, type `exit` to leave the debugger and resume the program. To prevent the debugger from running on every `POST /tasks` submission, remove the call to `binding.pry` in your *server.rb* file (and also `require "pry"` if you are done using the debugger).

Once the task has been written we send the user back to the home page where we'll display the list again. Now we just need to change our home page to read the tasks from the file rather than using the hard-coded values:

```ruby
get "/tasks" do
  tasks = File.readlines("tasks.txt")
  erb :index, locals: { tasks: tasks }
end
```

The `File.readlines("tasks.txt")` line will open the *tasks.txt* file and return an array containing each line of the file. Since we're storing one task per line, this is exactly what we want.

One final thing to do before starting up the server again is to create a blank *tasks.txt* file. If there no such file we'll receive an error when running `File.readlines("tasks.txt")`. After stopping the server we can run the `touch` command to create the file if it doesn't exist:

```no-highlight
$ touch tasks.txt
$ ruby server.rb
```

Now when we visit [http://localhost:4567/tasks][localhost-tasks] and submit the form we should see the list of tasks updating. If we were to open the *tasks.txt* file we should see that it contains all of the entries that have been submitted so far. Since a file is persisted even after the program stops running the tasks will remain when the server is restarted.

### Resources

* [MDN: My first HTML form](https://developer.mozilla.org/en-US/docs/Web/Guide/HTML/Forms/My_first_HTML_form)
* [MDN: Sending and retrieving form data](https://developer.mozilla.org/en-US/docs/Web/Guide/HTML/Forms/Sending_and_retrieving_form_data)

### In Summary

Accepting user input and persisting data are two essential activities for most non-trivial web apps. Understanding how data is transferred from a client to the server and the difference between GET and POST requests is important for building web apps.

Whenever a user is **retrieving** information without intentionally modifying anything, use an **HTTP GET request**. If a user is submitting information back to the web application to either be persisted or otherwise modify any state (e.g. a user logging in), prefer an **HTTP POST request** (or variants of POST such as PUT, PATCH, DELETE, etc.).

A POST request contains any information being submitted in the **request body**. The request body contains a series of key-value pairs that have been **URL encoded** to ensure any special characters are transferred correctly. The most common way to submit information is via an **HTML form** where the parameters are grabbed from the form inputs.

[todo-sample-code]: https://github.com/LaunchAcademy/curriculum/tree/master/lessons/dynamic-web-pages/sample-code
[localhost-tasks]: http://localhost:4567/tasks
