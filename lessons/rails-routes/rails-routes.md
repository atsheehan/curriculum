---
title: Introduction to Routes
author: dpickett
complexity_score: 5
scope: core
type: review
group_type: individual
tags: routes
---

### Contents

In this assignment, we will explore the Rails router.

If we think of the MVC stack like a workplace, where each department has its own specific function, we can think of the Rails router like workers in the mailroom. They take requests in and direct them to their desired destination. The Rails router is responsible for taking an HTTP request and forwarding it to its intended destination - a controller action.

### Learning Goals

* Examine default routes via `rake routes`
* Create a route manually for a resource
* Examine named routes and incorporate **url\_helpers**: `*_path` and `*_url`
* Incorporate **rake routes** to correlate named routes, URLs, and controller-action pairs
* Connect resources in `config/routes.rb` to their corresponding controllers
* Understand the HTTP methods and how they correlate to Rails RESTful actions

### Resources

* [Rails Routing From the Outside In (Rails Guides)](http://guides.rubyonrails.org/routing.html)
* [CRUD Verbs and Actions](http://guides.rubyonrails.org/routing.html#crud-verbs-and-actions)

### Implementation Notes

With previous layers of the stack, we had many different files to work with. Fortunately, in the context of our routes, we only have a single file to deal with, located at `config/routes.rb`. We'll explore routes using the [EventTracker application](https://github.com/launchacademy/event_tracker) which can be setup with the following commands:

```no-highlight
$ cd ~/Dropbox/launchacademy
$ git clone git@github.com:LaunchAcademy/event_tracker.git
$ cd event_tracker
$ bundle install
$ rake db:setup
```

#### Routes in Sinatra vs. Rails

You may recall that in our Sinatra apps, we specified our routes in our `server.rb` file:

```ruby
# sets a route for GET '/events'
get '/events' do
  @events = Event.all
  erb :index
end
```

The corresponding controller action in a Rails app would look like this:

```ruby
# does not set the route, though
# this action will be triggered by
# GET '/events' as well
def index
  @events = Event.all
end
```

In Rails, our controller does *not* specify the routes associated with each action. Instead, those routes are specified in `config/routes.rb`, and Rails makes some assumptions about which controller action each route maps to.

#### Default Routes

To understand how Rails correlates each route with a controller action, let's return to our Event Tracker application.

If we open our `config/routes.rb` file, we should see the following:

```ruby
EventTracker::Application.routes.draw do
  resources :events
end
```

That one line of code, `resources :events`, provides us with routes for all seven of the CRUD actions in our `EventsController`. `resources` is a helper method provided by Rails that helps us to avoid having to manually specify each of these routes individually.

To see a list of these routes, run `rake routes` in your terminal:

```no-highlight
    Prefix Verb   URI Pattern                Controller#Action
    events GET    /events(.:format)          events#index
           POST   /events(.:format)          events#create
 new_event GET    /events/new(.:format)      events#new
edit_event GET    /events/:id/edit(.:format) events#edit
     event GET    /events/:id(.:format)      events#show
           PATCH  /events/:id(.:format)      events#update
           PUT    /events/:id(.:format)      events#update
           DELETE /events/:id(.:format)      events#destroy
```

Let's focus on the `Verb` and `URI Pattern` columns. Here, you can see that we've got all the combinations of HTTP verbs and relative paths we need to trigger each of our CRUD actions.

The `Controller#Action` column helpfully shows us which action that HTTP request will trigger. We can see, for example, that:

* A `GET /events` request will trigger the `EventsController#index` action
* A `POST /events` request will trigger the `EventsController#create` action
* A `PATCH /events/:id` or `PUT /events/:id` request will trigger the `EventsController#update` action

#### Named Routes

Now let's look at the `Prefix` column in our `rake routes` output. This column lists prefixes for what we call **named routes**. Named routes are methods Rails provides for us to easily reference a route without having to manually type an absolute path. To refer to the `/events/new` path, we can add `_path` to the end of the `new_event` prefix:

```no-highlight
new_event_path
```

Named routes can be used to specify specific paths throughout our Rails application. They are often used in controller actions (e.g. to `redirect_to` another path) or in views (e.g. to `link_to` a path in our app).

*Note:* For paths that include a particular `:id`, the object must also be passed to the named route as an argument. Take this example in our Event Tracker's show page, `app/views/events/show.html.erb`:

```erb
<%= link_to 'Edit', edit_event_path(@event) %>
```

By clicking this link, the user will be taken to the `edit` page for the `@event` specified in the `EventsController#show` action.

#### Modifying the Default Routes

Like many aspects of Rails, the resources invocation follows convention over configuration. However, we can override Rails' assumptions to fit our needs.

##### Exclude Certain Routes Using Only and Except

Specifying `resources :events` will generate all seven CRUD actions. In some cases we don't want all of the CRUD actions to be available so we can use the keywords **only** and **except** to prevent Rails from generating routes for certain controller actions.

Say we don't want to allow users to create, edit, or delete events.  All they can do is view events or a particular event's page. We could delete all actions except `index` and `show` from our `EventsController`, and modify our `routes.rb` file to only include routes for those two actions:

```ruby
resources :events, only: [:index, :show]
```

Now say we want to allow users to add and edit events, but not to delete them. We'd add back our `new`, `edit`, `create` and `update` actions, and update our `resources` invocation as follows:

```ruby
resources :events, except: [:destroy]
```

#### Mapping Your Root

It is often important to specify what controller action is hit when a user navigates to your **root**. This is what action will be hit when your use navigates to `/`. We can specify the action in the format of `controller#action`. For example, if we want our root path to display a list of events we could send them to the `index` action of the `EventsController`:

```ruby
root to: "events#index"
```

#### Reviewing RESTful Actions

It is important to review how our resources map to RESTful actions, and how those actions correlate to our database CRUD operations.

For the events resource:

* A POST to `/events` **creates** an event
* A GET to `/events` **retrieves** the collection of events
* A GET to `/events/3` **retrieves** the event with an id of 3
* A PUT or PATCH to `/events/3` **updates** the issue with an id of 3
* A DELETE to `/events/3` **destroys** the issue with an id of 3

### Rules to Follow

#### REST gives us a way to express database CRUD operations through HTTP

REST is a standard way for developers to express CRUD operations through an HTTP interface. This means that a developer can guess at what's happening in the database based on the URL and HTTP method that is being utilized. This convention makes for a more coherent and understandable URL structure.

#### Use resources as much as possible

We'll learn later that there are other, unconventional ways to create URLs for our Rails application. You can see many of those ways in the commented out lines in `config/routes.rb`. Because REST provides us with a clean way to express intended database operations through HTTP, we want to adhere to what's conventional and most expressive. This will make our APIs easier to understand, and it will be easier for new developers to understand what we've built.

### Why This is Important

#### Following Rails Conventions Makes Your Code Easier to Understand

As a developer, you will encounter many applications and many different approaches to software. Rails provides us with some guidance and opinions on what should be consistent from app to app. This is the essence of **convention over configuration**, and it provides Rails developers with a common language and standard for writing our applications.

#### Sensible URLs make it easier for other developers and your users to understand

Having worked with scaffolds now, you should be able to easily identify what controller action correlates with what database operation. It makes it very easy for you as a developer to navigate within the codebase as well as in your browser.
