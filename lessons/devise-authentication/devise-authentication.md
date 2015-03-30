Devise is a well-documented gem that provides authentication services to web applications. In this article we'll discuss how to implement Devise in a Rails application.

### Learning Objectives

* Implement an authentication solution for a Rails application

### Authentication

Most web applications today have mechanisms for registering and signing in as a user. This allows users of the application to maintain a profile and to save all of their relevant information. The [`devise`](https://github.com/plataformatec/devise) gem gives us an easy way to make this happen in our Rails applications.

We have supplied screencasts for integrating Devise for traditional registration and authentication capabilities. Observe how **Outside-In Development** is used for this implementation.

<iframe src="//player.vimeo.com/video/75274695" width="500" height="281" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>

<iframe src="//player.vimeo.com/video/75263670" width="500" height="281" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>

The following sections will document the steps we've taken to add user authentication to a Rails application.

1. Write a failing acceptance test for registration. Every new feature should start with a failing acceptance test. Write a test that walks through your registration process. Be sure to include all of the fields you want to capture as part of your registration workflow.
2. Add `gem "devise"` to the `Gemfile`.
3. Bundle and install Devise with `bundle && rails generate devise:install && rails generate devise:views`. Like Rails itself, third party gems can supply generators for us to use. Devise supplies many generators. `devise:install` gives us the basics, while `devise:views` provides us with the ERB that we can customize.
4. Generate the `User` model with `rails generate devise <Model Name (usually user)>`. This is where the real magic happens. Here, we're generating the user model with all of Devise's authentication functionality baked in.
5. Write passing unit behaviors that test your user model. We often want to customize what devise provides us as a default. For example, we always like to add `first_name` and `last_name` attributes to our user table. Be sure to start with failing unit behaviors before you implement those custom behaviors. Modify your migration as necessary to support these additional functions.
6. Migrate with `rake db:migrate && rake db:rollback && rake db:migrate` to add the users table.
7. Modify `ApplicatonController` to allow all attributes to be saved from the user registration form. This is only necessary if we include additional fields such as name or biography to our user model. For example, if we added a `first_name` and `last_name` we would have to modify `app/controllers/application_controller.rb` as follows:

```ruby
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << [:first_name, :last_name]
  end
end
```

This allows the `first_name` and `last_name` attributes to be mass assigned.

8. Get the acceptance test to pass. Fill in the required fields and submit the registration form.

### Features of Devise

The following sections discuss how we can use Devise once it has been integrated in our application.

#### Customizing Sign In and Registration Views

We can ask Devise to provide us with versions of the view files via `rails generate devise:views`. This is useful to ensure that our sign in and registration page have the same look and feel as the rest of the application. If we add additional fields to our user model then we can update the registration and account update pages to include them on the form.

#### Controllers And Session

Devise uses the session to remember who is currently logged in. It provides the helper method `current_user` that will return the user who is currently logged in or `nil` if they are unauthenticated.

Remember that `current_user` is a method, not a variable. This method is available in views as well as controllers; you can use it as the basis of a test to determine what elements and partials should be rendered on a page, or set the names of partials, or alternate action views in the controller.

#### Models

Devise depends upon a model that contains the login object. You can call this User, Person, or anything else you want, but remember that once decided, changing is relatively difficult, as Devise uses this in many locations. We recommend User as the default name for the entity that Devise will use to manage logged in entities.

#### Routes

Devise works in part by having routes that direct the user to login pages. The default situation expects that there will be a login route of some kind. It is possible to use Devise Authorization without using the routes that it generates, but it is not recommended that you override or modify this to begin with. Use the tutorials and readme information to establish a running app with Devise, and then study `rake routes` output. Once you understand the mechanisms that Devise is using, you can get more creative.

#### Requiring Authentication To Access A Page

Devise provides a simple helper method to require that a user signs in before viewing a page: `authenticate_user!`.

Say we have a social network with a `Post` model, and we want users to sign in before they can view, create, edit, or delete any posts. In our `PostsController`, we can include a call to `authenticate_user!`:

```ruby
class PostsController < ApplicationController
  before_action :authenticate_user!

  # our controller actions
end
```

This will run the `authenticate_user!` method before any of the actions in our controller. If a user is not already logged in, they will be redirected to the login page.

If we only wanted to prevent unauthenticated users from creating, editing, or deleting posts, we could modify our `before_action` to exclude the `index` and `show` actions:

```ruby
before_action :authenticate_user!, except: [:index, :show]
```

Now, unauthenticated users can view posts but not create, edit, or modify them.
