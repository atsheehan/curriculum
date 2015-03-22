---
title: Controllers and Parameters
author: dpickett
complexity_score: 3
scope: core
type: review
group_type: individual
tags: params, rails
---

In the previous assignment, you learned that when a controller is called via an **HTTP request**, an internal process connects the request to a particular controller method based on the request's path and HTTP method.

The two most frequently used HTTP methods are GET and POST.

In this assignment, we'll focus on the values that are passed to controller actions. We'll also look at how we can disrupt the connection between the method that handles the request, and the action view that displays it. We'll also learn to use strong parameters to filter user-supplied input.

### Learning Goals

* Use parameters in a controller context
* Understand why accepting arbitrary user input is dangerous
* Whitelist user-specified attributes with strong parameters

### Resources

* [Rails Guide to Strong Parameters][1]

### Implementation Notes

#### Getting Started

We'll refer to the [EventTracker application](https://github.com/launchacademy/event_tracker) we've used in prior assignments.

#### Params in GET vs. POST requests

You may recall from your work with Sinatra that, in a GET request, parameters are passed in via the URL. We might define a `get` block in our `server.rb` file like so:

```ruby
get '/events/:id' do
  @event = Event.find(params[:id])
  erb :event
end
```

In this case our params hash should contain a key-value pair for `id` when we navigate to some `/events/<event_id>` URL in our browser. In a Rails context, this would look like:

```ruby
# GET /events/:id
def show
  @event = Event.find(params[:id])
end
```

In both cases, the params hash that is generated contains information taken directly from the URL. We specify which `Event` we would like to display by passing the `id` of the `Event` as the `:id` parameter in our URL. The value for `:id` is then available to us in our controller inside of the `params` hash. Without the `id`, our controller can't tell the Model to retrieve the required record.

#### Creating an object from a POST request

In a POST request, parameters are usually supplied through a form, though additional parameters may be supplied via the URL. To review how objects are created from a POST request, let's take the example of a user registering for an account.

Consider a model for representing a user's account and login. A very basic and naive implementation of our database migration might look something like:

```ruby
class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username, null: false
      t.string :password, null: false
      t.string :role, null: false, default: 'member'

      t.timestamps
    end
  end
end
```

We've included a username and password for the user to sign in as well as a role to indicate whether they are a normal member or an admin. (Note that this is **not** a secure way to handle user logins and is only being used for demonstration. Use a gem such as `devise` for properly handling and storing user credentials).

When a user registers, we'll prompt them for a username and password. We don't ask for their role since we want all new users to default to the 'member' state. Our form for user registration might look something like this:

```HTML
<form action="/users" method="post">
  <label for="user_username">Username</label><br>
  <input id="user_username" name="user[username]" type="text" />

  <label for="user_password">Password</label><br>
  <input id="user_password" name="user[password]" type="text" />

  <input name="commit" type="submit" value="Create User" />
</form>
```

When a user fills in this information and submits the form, an HTTP POST request will be sent to `/users`, which will trigger the `create` action in the `UsersController`. The parameters for this request will include the username and password parsed by Rails in the following format:

```ruby
params = { "user" => { "username" => "foo", "password" => "bar" }, "commit" => "Create User" }
```

These parameters (`params["user"]["username"]` and `params["user"]["password"]`) reflect the names of the input fields on the form.

We have our user input, now we need to save this information to the database by creating a new `User` record. We can create our new `User` object in one of two ways: (1) setting each attribute individually, or (2) using a shortcut called **mass assignment** to set all of the user's attributes at once.

Using the first method, our `create` action might look something like this:

```ruby
def create
  # params["user"] = { "username" => "foo", "password" => "bar" }
  user = User.new
  user.username = params["user"]["username"]
  user.password = params["user"]["password"]
  user.save!
  redirect_to user
end
```

Alternatively, we can use mass assignment to set all of the user's attributes at once by supplying a hash of user attributes to our `User.new` invocation:

```ruby
def create
  # params["user"] = { "username" => "foo", "password" => "bar" }
  user = User.new(params["user"])
  user.save!
  redirect_to user
end
```

Assuming the user filled in both fields and the validations pass, we should have a new user record in the database with username set to `"foo"`, the password set to `"bar"`, and the role defaulting to `"member"`. So far so good.

The benefit of using mass assignment instead of setting each attribute individually is that if we add an attribute to the `User` model such as `email`, we don't need to modify our `create` action. We simply add a field to our user registration form for email, so that our params hash will look like:

```no-highlight
params = { "user" => { "username" => "foo", "password" => "bar", "email" => "baz" }, "commit" => "Create User" }
```

#### Security risks with mass assignment

There is one major downside to using mass assignment like we did in our `create` action above. Mass assignment exposes **all** of the attributes of our `User` model. In addition to setting the username and password, a malicious user could also set the role by including it in the params hash. It is very possible (and likely) that a user will come along and submit the following parameters:

```ruby
params = {
  "user" => {
    "username" => "foo",
    "password" => "bar",
    "role" => "admin"
  },
  "commit" => "Create User"
}
```

But how could a user submit `"role" => "admin"` if we only include the username and password fields on the input form?

One of the key points to remember when handling user-defined input is that it is exactly that: user-defined. The form we provided is just a convenience for users to interact with our site. It's also possible for malicious users to construct their own HTTP requests and inject any additional parameters. For example, we could create a user outside of our browser by talking to the web server directly with the `curl` utility:

```no-highlight
curl -d 'user[email]=foo&user[password]=bar&user[role]=admin' http://localhost:3000/users
```

The `curl` utility can be used to send HTTP requests directly to a server. Here we've indicated that we want to send an HTTP POST request with `-d` and specified the input parameters using `key=value` pairs separated by ampersands. This will call the same method in our controller that is invoked when a user submits the form except now we've padded our input parameters with `user[role]=admin`. No errors will be thrown or warnings logged since it is a valid HTTP POST request.

This command would create a new user with administrative privileges. A non-privileged user would have registered for our site and gained administrative privileges, at which point they could wreak havoc. This is no good.

#### Strong params

Newer versions of Rails now come with built-in safeguards to prevent these kinds of attacks. Starting with Rails 4, the **strong_parameters** plugin is included by default which requires that we **whitelist** attributes that can be set by a user. Using strong\_parameters (or strong\_params, as it is usually called) allows us to reap the benefit of mass assignment in our controllers while protecting us from malicious user input.

Let's modify our user `create` action to make use of strong_params. In this case, we'll want to whitelist the `username` and `password` attributes and leave out the `role`.

```ruby
def create
  # params["user"] = { "username" => "foo", "password" => "bar", "role" => "admin" }
  # strong_params will permit "username" and "password" but ignore "role"
  user = User.new(params.require(:user).permit(:username, :password))
  user.save
  redirect_to user
end
```

You can see that we're calling a chain of two methods on our `params` hash: `require` and `permit`.

* The expression `require(:user)` is expecting there to be at a minimum `{ "user" => { ... }}` in the parameters hash. If a user key is not provided, it will throw an exception.
* The `permit(:username, :password)` expression will allow the `"user" => { "username" => "foo", "password" => "bar" }` portion of parameters to pass through but will silently reject any others (e.g. `"role" => "admin"` will be ignored).

Strong parameters give us a bit more control over what we'll accept and should be used anytime we're persisting user-supplied data. For the majority of controllers, we can follow the format of:

```ruby
params.require(:resource).permit(:attribute_one, :attribute_two, ...)
```

In many cases, we will find that we need to refer to the same set of parameters in multiple actions in the same controller. For example, if we had an `update` action on our `UsersController`, we'd probably want to accept the same parameters as we did for `create`. To keep our controller DRY, we should extract that code into a separate private method:

```ruby
class UsersController < ApplicationController

  def create
    user = User.new(user_params)
    user.save
    redirect_to user
  end

  def update
    user = User.find(params[:id])
    user.update(user_params)
    redirect_to user
  end

  private
  # call this method inside our create and update actions
  def user_params
    params.require(:user).permit(:username, :password)
  end
end
```

This is what the Rails scaffold creates when you generate a controller. Take a look at the Event Tracker's `EventsController`. At the bottom, you should find a private method called `event_params`:

```ruby
def event_params
  params.require(:event).permit(:location)
end
```

For more advanced use cases dealing with nested attributes, refer to the [Rails Guide on Strong Parameters][1] for example usage.

{% quick_challenge %} **Quick Challenge:** Using pry in Rails, navigate to a few different pages in your Event Tracker app and inspect `params`.

First, add `pry-rails` to the development group of your `Gemfile` and run `bundle` at the command line. Insert a `binding.pry` statement at the beginning of the **show** method, right after the definition line.

Now, try navigating to the **show** action. The page should appear to be continuously loading. If you look in the terminal window where you started your server, you should recognize a familiar pry prompt. The web browser will continue to wait until you type `exit` on the pry prompt. Check out what the `params` hash looks like by typing `params` into the prompt and hitting enter.

Try doing the same with the **create** action. Add the `binding.pry` statement and fill out the form to create a new event. Inspect `params` inside of pry.

Think of invoking `binding.pry` like placing a pause button in the middle of your program. When the program is paused, you can take some time to explore and look around.

{% endquick_challenge %}

### Rules to Remember

#### All User Input Is Evil

Not really, but it's a good practice to think this way. Aside from fostering an overly-pessimistic view of the world, you'll take extra precautions to ensure that any actual malicious input is properly treated and sanitized before it can do some real damage to your application.

#### Whitelist the Minimum Number of Attributes

It's tempting to whitelist all of the attributes for a model so that you don't have to deal with them in the future. This might make development slightly easier but you'll also be carelessly exposing yourself to attack. Even though it seems unlikely that a user will attempt to inject arbitrary parameters it does happen, frequently carried out by bots that will attempt a large number of common attacks on a website to probe for any vulnerabilities. It is better to be safe and whitelist only those attributes that you expose on your forms.

#### Strong Parameters Are New

Strong parameters were introduced as the new default in Rails 4. Previously to that, mass assignment protection was defined in the model using `attr_accessible`. The concept is similar in that you have to whitelist the attributes that can be set via mass assignment (e.g. `attr_accessible :username, :password`). Moving the filtering from the model to the controller allows more fine grained control over what different controllers have access to change at the expense of potentially duplicating a whitelist in multiple locations.

### Why This is Important

Understanding the dangers of accepting arbitrary user-defined input will go a long way to help understand the various types of security incidents common in web development. Strong parameters force us to think about which parameters should be settable by a user and errs on the side of caution by rejecting everything else. It is a good habit to get into to treat all user input with suspicion and assume that every user is malicious.

#### As With Ruby, Parameters Allow For More Flexible Software

If we couldn't pass arguments to Ruby methods, we'd have a pretty difficult time creating flexible, adaptable software with terse code. Since controller actions are simply Ruby, it shouldn't surprise us that a method of parameter passing is part of the Rails framework.

In reviewing the actual methods you find in a controller, however, it is striking that none of them take explicit parameters. Instead, the **params** object is always available whenever a controller method runs. And the values for those parameters are either encoded in the URL, or passed separately in the request body when forms are submitted. Understanding this is a key insight in shifting your thinking to web application development, as opposed to simply writing Ruby code.

[1]:http://guides.rubyonrails.org/action_controller_overview.html#strong-parameters
