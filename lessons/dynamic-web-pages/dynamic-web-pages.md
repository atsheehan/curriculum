We can create web pages using just HTML and CSS, but since many web applications are constantly receiving and displaying new information they can become stale quickly. In this article we look at how we can make our web pages dynamic by creating HTML on the fly using Ruby and ERB templates.

### Learning Goals

* Generate HTML containing dynamic values in Sinatra.
* Generate HTML from an ERB template.
* Extract patterns from HTML into a template file.

### Generating HTML

In the [HTTP article](/lessons/http) we created a simple TODO web application that would serve up our HTML and CSS files when requested (sample code can be found [here][todo-sample-code]. In the end our project directory should have resembled the following:

```no-highlight
/server.rb
/public/home.html
/public/home.css
```

We have our *server.rb* file that sets up Sinatra and then *home.html* and *home.css* containing our HTML and CSS. Whenever someone requests `GET /home.html` or `GET /home.css` they'll receive the same file, every time. Once we're done development and deploy our application, these files don't change. These are known as **static files** or **assets**.

The problem with this is that unless we're hosting something like a blog, our site is not very interesting. Most websites have some sort of dynamic content to them. If we visit the front page of [CNN](http://www.cnn.com), we'd expect to be shown a different set of articles from yesterday. The outline of the page stays the same but the content does not.

Let's explore how we can make a web page dynamic using Sinatra. We can add the following to *server.rb*:

```ruby
get "/hello" do
  "<p>Hello, world!</p>"
end
```

Here we're adding a **route** to our web app. The `get "/hello"` call is specifying that if we have an incoming HTTP request for `GET /hello`, run the code within this block. We can start up the web server with the following (if a server is already running it can be shutdown by pressing `Ctrl` + `C`):

```no-highlight
$ ruby server.rb
```

When we visit [http://localhost:4567/hello][localhost-hello] we should be presented with our "Hello, world!" message.

Since we're writing the HTML in our Ruby source file it gives us the opportunity to modify the contents before we send them back in an HTTP response. Let's try including the current time:

```ruby
get "/hello" do
  "<p>Hello, world! The current time is #{Time.now}.</p>"
end
```

For this to take effect, we need to restart our web server. Pressing `Ctrl` + `C` will shut down the server and it can be restarted by running `ruby server.rb`. Visiting [http://localhost:4567/hello][localhost-hello] again we should be greeted with the current time:

```no-highlight
Hello, world! The current time is 2015-02-05 13:19:09 -0500.
```

Notice how we didn't have to explicitly hard-code the time into our HTML. Those values were generated for us by calling `Time.now` in Ruby. If we refresh the page, the time shown should update. Each request we send our web application it will regenerate the HTML, inserting whatever the current time is.

Let's go back to our TODO list. Here is the static HTML page we created in *public/home.html*:

```HTML
<!DOCTYPE html>
<html>
  <head>
    <title>Basic HTML Page</title>
    <link rel="stylesheet" href="home.css">
  </head>

  <body>
    <h1>TODO list</h1>

    <ul>
      <li>pay bills</li>
      <li>buy milk</li>
      <li>learn Ruby</li>
    </ul>
  </body>
</html>
```

If we wanted to we could take this entire chunk of HTML and define a `get "/tasks"` block within our *server.rb* file:

```ruby
get "/tasks" do
  # The three quotes below is simply to treat everything below as a string
  '''
  <!DOCTYPE html>
  <html>
    <head>
      <title>Basic HTML Page</title>
      <link rel="stylesheet" href="home.css">
    </head>

    <body>
      <h1>TODO list</h1>

      <ul>
        <li>pay bills</li>
        <li>buy milk</li>
        <li>learn Ruby</li>
      </ul>
    </body>
  </html>
  '''
end
```

After restarting the server (`Ctrl` + `C` followed by `ruby server.rb`) we should see our TODO list when we visit [http://localhost:4567/tasks][localhost-tasks].

This isn't much better than when we loaded the HTML from *home.html*, but now we're writing it in Ruby. Considering a TODO list will change over time, we probably want it to be more dynamic. If we add more tasks we would just add more `<li>` elements:

```HTML
<ul>
  <li>pay bills</li>
  <li>buy milk</li>
  <li>learn Ruby</li>
  <li>try and take over the world</li>
</ul>
```

And after we pay the bills and have bought our milk, we can cross them off the list:

```HTML
<ul>
  <li>learn Ruby</li>
  <li>try and take over the world</li>
</ul>
```

We can start to see a pattern in how we create our HTML. Given a list of *n* tasks, we want our output to resemble:

```HTML
<ul>
  <li>Name of the first task</li>
  <li>Name of the second task</li>
  <!-- ... -->
  <li>Name of the nth task</li>
</ul>
```

This suggests that we can refactor using a loop where, given a list of tasks, we iterate through each one and output the `<li>` element with the task name.

Let's see if we can do this in our web app. We can change our `get "/tasks"` block to include the following:

```ruby
get "/tasks" do
  tasks = ["pay bills", "buy milk", "learn Ruby"]

  html = '''
  <!DOCTYPE html>
  <html>
    <head>
      <title>Basic HTML Page</title>
      <link rel="stylesheet" href="home.css">
    </head>

    <body>
      <h1>TODO list</h1>
      <ul>
  '''

  tasks.each do |task|
    html += "<li>#{task}</li>"
  end

  html += '''
      </ul>
    </body>
  </html>
  '''
end
```

Here we've pulled our list of tasks out of the HTML and stored them in an array `tasks`. Then we start building up a string `html` that will store the dynamically generated HTML.

The interesting part is when we start adding the list of tasks. Since they are stored in an array we can call the `each` method to iterate over each task and append it to the HTML string being generated. Once we're done adding tasks, we add the rest of the HTML and return the full string.

This seems like a lot of code to replace something that was already working. If we restart the server and visit [http://localhost:4567/tasks][localhost-tasks] we'll see the same exact page as before. The benefit is that our code is now a lot more flexible. By pulling the tasks out of the HTML and storing them in an array, we now have many more options for how we can populate the page. For example, rather than hard-coding the tasks we can instead read them from a file or a database. All we have to do is update the `tasks` variable and the appropriate HTML will be generated for us.

### Templates

Although our code is more flexible, it's a bit ugly. Having to build the HTML in chunks becomes tedious for all but the simplest pages. What we can do instead is move our HTML structure into a **template** file.

An HTML template file is similar to the *home.html* we created previously except it also allows us to add code to make the page dynamic. Ruby comes with a templating system called **ERB** that let's us embed snippets of Ruby within the template file. For our page, we can add logic that will iterate over a list of tasks and output each one in a list.

Let's create a directory called *views* and store our template in *views/index.erb*:

```HTML+ERB
<!DOCTYPE html>
<html>
  <head>
    <title>Basic HTML Page</title>
    <link rel="stylesheet" href="home.css">
  </head>

  <body>
    <h1>TODO list</h1>

    <ul>
      <% tasks.each do |task| %>
        <li><%= task %></li>
      <% end %>
    </ul>
  </body>
</html>
```

This is similar to the *home.html* file except for the one snippet below:

```HTML+ERB
<% tasks.each do |task| %>
  <li><%= task %></li>
<% end %>
```

Here, we've embedded some Ruby code in ERB tags (`<% %>`). When we render this template, all of the Ruby code in ERB tags will run. This chunk of code will loop through the `tasks` array and output each one as an `<li>` element. Anything found within an ERB tag will be treated as Ruby code, and since we're opening a `do` block on the first line, we also need to include an `end` block as well.

Normally an ERB tag won't output anything in the template unless we use the `<%= %>` tag. The only code that we want to output is the variable containing the task name which is why we included `<%= task %>`. All of the other ERB tags do not have useful output so we just use the regular `<% %>` tags.

Before we can get this working we also need to update our *server.rb* file:

```ruby
require "sinatra"

get "/tasks" do
  tasks = ["pay bills", "buy milk", "learn Ruby"]
  erb :index, locals: { tasks: tasks }
end

# These lines can be removed since they are using the default values. They've
# been included to explicitly show the configuration options.
set :views, File.join(File.dirname(__FILE__), "views")
set :public_folder, File.join(File.dirname(__FILE__), "public")
```

After moving the HTML to a template our code will be a lot less verbose but we need to specify which template we're going to render using `erb :index`. This will look for a file in the *views* directory named *index.erb*. We also need to specify which tasks to print out by passing in our array to the template (via `locals: { tasks: tasks }`).

Once we restart the server and visit [http://localhost:4567/tasks][localhost-tasks] we should see the same page, this time loaded from a template. Try changing the tasks in the array and you should see that the list updates with your new items (after restarting the server).

### Dynamic Routing

So far we've only dealt with a single routes that don't change (e.g. `get "/hello"`, `get "/tasks"`). What if we wanted to have a page for each task in our TODO list? We could start defining routes for each task that we saw before:

```ruby
# The %20 is a special character to represent empty space in a URL
get "/tasks/pay%20bills"   #...
get "/tasks/buy%20milk"    #...
get "/tasks/learn%20ruby"  #...
```

This works if the number of tasks is small and constant, but our TODO list will most likely change over time. Rather than writing new routes for each task (which requires more Ruby code) we can rely on the **URL pattern** to define a single route that matches all of the above:

```ruby
get "/tasks/:task_name"
```

When a request comes in, Sinatra looks through the routes we have defined and uses the first one that fits the pattern. This route will be used for any request that fits the `GET /tasks/*` pattern where `*` represents a string of characters.

Once we have a request that matches this pattern (e.g. `/tasks/buy%20milk`), we need some way to figure out what name was used in the URL. This is where the `:task_name` portion of the route comes into play. Sinatra will extract information from a request and store in a Hash called **params**:

```ruby
get "/tasks" do
  tasks = ["pay bills", "buy milk", "learn Ruby"]
  erb :index, locals: { tasks: tasks }
end

get "/tasks/:task_name" do
  erb :show, locals: { task_name: params[:task_name] }
end
```

Here we can see that our route is using `params[:task_name]` to extract the name of the task from the URL. Let's create another ERB template in *views/show.erb* to display the task to the user:

```HTML+ERB
<!DOCTYPE html>
<html>
  <head>
    <title>Basic HTML Page</title>
    <link rel="stylesheet" href="/home.css">
  </head>

  <body>
    <h1>
      The task is <%= task_name %>
    </h1>

    <a href="/tasks">All tasks</a>
  </body>
</html>
```

Now we can visit [http://localhost:4567/tasks/buy%20milk](http://localhost:4567/tasks/buy%20milk) and we will see the "buy milk" task on its own page. We can then visit [http://localhost:4567/tasks/learn%20ruby](http://localhost:4567/tasks/learn%20ruby) and we'll see that we need to "learn ruby". Both pages are using the same code and the same template: the `get "/tasks/:task_name"` route is rendering the *views/show.erb* template. The difference is in our URL which contains the name of the task we want to display.

On a side note, the `<link>` element changed from `href="home.css"` to `href="/home.css"`. We changed the reference from a *relative* path to an *absolute* one which is necessary since our `/tasks/buy%20milk` URL has two segments separated by slashes. Without the initial slash we would be looking for our stylesheet relative to `/tasks/buy%20milk` which is `/tasks/home.css` instead of `/home.css`.

To make navigating the app a bit easier, we can also update the *views/index.erb* template to include a link to the details page for each task:

```HTML+ERB
<% tasks.each do |task| %>
  <li><a href="/tasks/<%= task %>"><%= task %></a></li>
<% end %>
```

The line `<a href="/tasks/<%= task %>">` will generate a link with the task name embedded within the URL for each of the tasks in the array.

### In Summary

Being able to dynamically construct HTML makes our web pages significantly more interesting and flexible. ERB templates are a commonly used in Ruby web frameworks as a way of combining the HTML structure of a page with the content to be displayed.

To create a dynamic web page, we first define a **route** in our application that *renders* an **ERB template**. We can pass data into our templates to generate different pages with the same structure. It's also possible to extract parameters from the URL to determine what content to display using **dynamic routes**. URL pattern matching is a powerful way of reusing routes and templates to generate a large number of pages.

Although ERB templates have the ability to run arbitrary Ruby code it's best to keep it at a minimum. Putting lots of logic within a template (aka the view layer) makes it more difficult to understand what will be rendered and tightly couples the view layer with the rest of the application.

[localhost-hello]: http://localhost:4567/hello
[localhost-tasks]: http://localhost:4567/tasks
[todo-sample-code]: https://github.com/LaunchAcademy/master/tree/ats-dynamic-web-pages/lessons/http/sample-code
