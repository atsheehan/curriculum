---
title: Controller Basics
author: atsheehan
complexity_score: 2
scope: core
type: review
group_type: individual
tags: rails, mvc, controllers, sinatra
---

### Contents

In this assignment, you'll be introduced to the concept of controllers, a core member of the Model-View-Controller (MVC) paradigm.

### Learning Goals

* Become familiar with the role of controllers in MVC
* Clone and explore a basic Rails application
* Identify the location of controller files in typical Rails applications
* Open, identify and explain elements of a controller file
* Compare a controller in Rails to methods in Sinatra

### Resources

* [Getting Started with Rails][3]
* [Rails Guide to Controllers][1]
* [Rails Guide to Routing][2]

### Implementation Details

#### The Model-View-Controller Pattern

The Model-View-Controller paradigm is useful and pragmatic design pattern found in web development and other areas of software. One of the goals of MVC is to separate information (the **Model**) from how it is being presented to the user (the **View**). This is largely mediated by the **Controller** which communicates with the other two layers.

This separation of concerns between the layers provides lots of flexibility. Since there are no direct ties between any particular model and view, we can present a model in several different ways. Maybe we want to render the model in HTML for a browser, or return it in a JSON or XML format for other developers to use. Either way, it is ultimately the controller that is responsible for how a request is processed and returned.

In Rails, the controllers (along with the routes) define the endpoints of our applications. Each HTTP request that is handled by our application is sent to a controller **action** which talks to the appropriate models and renders a view. In this unit we'll introduce a basic Rails application that will be used to explore the basic structure of a controller and how the controllers and views work together.

#### Getting Started

For this assignment we'll work with an existing Rails application called `launcher_news`. To setup the app run the following commands:

```no-highlight
$ cd ~/Dropbox/launchacademy
$ git clone git@github.com:LaunchAcademy/launcher_news.git
$ cd launcher_news
```

Once we're in the directory, we have a few more steps to setup the application. First we can run:

```no-highlight
bundle install
```

This will download all of the necessary gems needed to run the app. After that completes, run:

```no-highlight
rake db:setup
```

This will create our database, run any migrations, and insert some seed data. Finally we can run:

```no-highlight
rails server
```

This will start up the rails application listening on port 3000. In a browser, we can navigate to [http://localhost:3000/](http://localhost:3000/) to see the homepage for Launcher News, a simple news link site created as a Rails demo.

#### Investigating Requests

Navigate to the home page [http://localhost:3000](http://localhost:3000). While clicking around, pay attention to how the URLs change in your browser's address bar. The controllers are tightly integrated to the URLs of a web application as they dictate which controller action gets triggered.

When we click the _Mozilla Playdoh_ link on the homepage, we should be shown some details about the article (a link and description) and our address bar should look something like `http://localhost:3000/articles/2`. The important part is the `/articles/2` segment. When we go to this URL, we're essentially telling the Rails server that we want to access an article that has an ID of 2.

Let's try to figure out what is happening. When we're running `rails server`, we should see a stream of log messages scrolling by in the terminal as we're accessing different parts of the site. After clicking on the _Mozilla Playdoh_ link, the latest log entry might look something like:

```no-highlight
Started GET "/articles/2" for 127.0.0.1 at 2013-08-04 11:17:54 -0400
Processing by ArticlesController#show as HTML
  Parameters: {"id"=>"2"}
  Article Load (0.2ms)  SELECT "articles".* FROM "articles" WHERE "articles"."id" = ? LIMIT 1  [["id", "2"]]
  Rendered articles/show.html.erb within layouts/application (0.4ms)
Completed 200 OK in 9ms (Views: 7.6ms | ActiveRecord: 0.2ms)
```

There's quite a bit of information here describing our request. The first line shows the path that we entered in our browser (`/articles/2`).

The second line actually reveals how our server is going to handle that request: using the `ArticlesController` and the `show` action to return HTML. We can also see that Rails is interpreting the 2 that we passed in as `{"id"=>"2"}` in the `params` hash. The `Article Load` line is logging a SQL request we're making to pull the article out of the database. After that, the Rails server renders the HTML using the view template found in `articles/show.html.erb`. Finally we see that the request returned with a HTTP 200 OK response in 9 milliseconds.

Not everything in the logs will make sense right now, but know that they can be an invaluable resource when trying to figure out how our application is behaving. The key points we're interested in now are that the `ArticlesController#show` action handled the request and that the page was rendered using the `articles/show.html.erb` template.

#### Getting to know the controller

In Rails, all controllers are stored in the `app/controllers` directory and all views are in the `app/views` directory. In our editor, if we open the `app/controllers/articles_controller.rb` we should see the following:

```ruby
class ArticlesController < ApplicationController

  # GET /articles
  def index
    @articles = Article.all
  end

  # GET /articles/1
  def show
    @article = Article.find(params[:id])
  end

  # GET /articles/new
  def new
    @article = Article.new
  end

  # POST /articles
  def create
    @article = Article.new(article_params)

    if @article.save
      redirect_to @article, notice: 'Article was successfully created.'
    else
      render action: 'new'
    end
  end

  # GET /articles/search
  def search
    @articles = Article.search(params[:query])
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def article_params
    params.require(:article).permit(:title, :description, :url, :submitter)
  end
end
```

The first five **methods** of `ArticlesController` (`index`, `show`, `new`, `create`, and `search`) are actions for our controller that correspond to different URLs (the last method `article_params` is private and is not accessible outside of this class). When we typed in `/articles/2` that corresponded to the `show` action on the `ArticlesController`. That results in the following method being run:

```ruby
# GET /articles/1
def show
  @article = Article.find(params[:id])
end
```

Without worrying too much about the details, this method pulls the article from the database with the ID specified in the parameters (the `2` from `/articles/2`) and saves it in an instance variable `@article`.

So then what? We ran our controller action, now we want to return something back to the user (HTML in this case). Rails by default will look for a template file named `app/views/<controller>/<action>.<format>`, so we expect that it rendered `app/views/articles/show.html.erb`. This is consistent with the HTTP request log above.

#### The Rails controller vs. the Sinatra `server.rb` file

The controller performs a very similar function to the `server.rb` or `app.rb` file in our Sinatra apps. Let's take the `ArticlesController#show` action as an example:

```ruby
# GET /articles/1
def show
  @article = Article.find(params[:id])
end
```

For comparison, the corresponding block in a Sinatra app might look like this:

```ruby
get '/articles/:id' do
  @article = Article.find(params[:id])

  erb :article
end
```

Like the Sinatra `get` block, the controller action defines an instance variable `@article` that we will reference later in the view. It also corresponds to a particular route in our application (`GET /articles/2`). However, there are two key differences:

* Routes are not defined in the controller.  In Sinatra, we defined our routes in our `server.rb` file. In Rails, we define our routes in a separate file (`config/routes.rb`), which we will discuss in a subsequent assignment.
* We do not specify a view template. Rails makes some assumptions about which template we want to render based on the name of the controller and action: By default, Rails will look for a template file named `app/views/<controller>/<action>.<format>` unless we explicitly tell it otherwise.  This is part of Rails' reliance on **convention over configuration**.

[1]: http://guides.rubyonrails.org/v2.3.11/action_controller_overview.html
[2]: http://guides.rubyonrails.org/routing.html
[3]: http://guides.rubyonrails.org/getting_started.html

### Rules to Follow

#### Use the Rails Logs To Orient You

When starting out, the Rails logs can help to bridge the cognitive gaps between Model, View, and Controller. You might not understand everything that's happening there just yet, but it will become increasingly clear as you learn more about the Rails stack.

#### Use Design Patterns To Guide Your Architecture

Design patterns are proven solutions to common architectural problems. Embracing design patterns allow you to use the experience of others as you develop your coding skills.

#### Use the Philosophies of MVC to Guide Application Design

MVC provides us with a cognitive framework for organizing our Rails applications. As you learn more about MVC, it will help you to develop more modular, flexible applications.

### Why This Matters

#### Controllers Provide the Intermediary Between the Model and the View

Think of controllers like a traffic cop that manages and directs the requests that come into your application. With its ability to interface with both the model and the view layers, your ability to command controllers is a vital aspect of being an effective Rails developer.
