# Lunar Kitchen

The Lunar Kitchen application is broken. You're given the skeleton of a Sinatra
app that includes some HTML/CSS and some of the basic code. Your job is to get
the app to a working state **without modifying the `server.rb` file.**

### Getting Started

```no-highlight
# Clone down the Lunar Kitchen Repo
git clone git@github.com:LaunchAcademy/sinatra-lunar-kitchen.git

# Move into the app directory
cd sinatra-lunar-kitchen

# Remove the old git history and start your own
rm -rf .git && git init && git add -A && git commit -m 'Initial commit'

# Install all the dependencies for the app
bundle install
```

If you don't already have the "recipes" PostgreSQL database, follow the
instructions below:

```no-highlight
curl -o /tmp/recipes_database.sql.gz https://s3.amazonaws.com/launchacademy-downloads/recipes_database.sql.gz
gunzip /tmp/recipes_database.sql.gz
createdb recipes
psql recipes < /tmp/recipes_database.sql
```

### Running the Tests

This app is broken. Lucky for you, somebody else already wrote some tests that
will help you figure out what the application is supposed to do.

These tests are written using [RSpec](https://github.com/rspec/rspec) and
[Capybara](https://github.com/jnicklas/capybara). Capybara is a testing tool
that is used to simulate a user interacting with your application in the
browser.

You can run the test suite with the following command:

```no-highlight
rspec spec
```

You should get an error that looks like this:

```no-highlight
Failures:

  1) User views recipes index page user sees all the recipes
     Failure/Error: visit '/recipes'
     NoMethodError:
       undefined method `all' for Recipe:Class
     # ./server.rb:17:in `block in <top (required)>'
     # ./spec/features/user_views_all_recipes_spec.rb:5:in `block (2 levels) in <top (required)>'

Finished in 0.01306 seconds (files took 0.47788 seconds to load)
1 example, 1 failure

Failed examples:

rspec ./spec/features/user_views_all_recipes_spec.rb:4 # User views recipes index page user sees all the recipes
```

This tells us that when we try to visit "/recipes", the test on line 4 of
the `spec/features/user_views_all_recipes_spec.rb` is failing. It's also telling us
that it's failing because an undefined `all` method for the `Recipe` class
is being called on line 17 of `server.rb`.

Use the hints given to you by the tests to track down the errors and figure out
how to fix them. It will probably also be helpful to check out a few of the
views and try to understand what they're doing.

**Work in small steps.** To fix this first error, all we need to do is add an
`all` method to our `Recipe` class:

```ruby
class Recipe
  def self.all
  end
end
```

This is obviously not the final version of the method but now we can run the
tests again and see what we need to do next.

```no-highlight
Failures:

  1) User views recipes index page user sees all the recipes
     Failure/Error: visit '/recipes'
     NoMethodError:
       undefined method `each' for nil:NilClass
     # ./views/recipes/index.erb:4:in `block in singleton class'
     # ./views/recipes/index.erb:-5:in `instance_eval'
     # ./views/recipes/index.erb:-5:in `singleton class'
     # ./views/recipes/index.erb:-7:in `__tilt_70277883157480'
     # ./server.rb:18:in `block in <top (required)>'
     # ./spec/features/user_views_all_recipes_spec.rb:5:in `block (2 levels) in <top (required)>'

Finished in 0.0133 seconds (files took 0.48435 seconds to load)
1 example, 1 failure

Failed examples:

rspec ./spec/features/user_views_all_recipes_spec.rb:4 # User views recipes index page user sees all the recipes
```

Now the test is telling us that when we visit '/recipes', our code breaks on
line 4 of `views/recipes/index.erb`, by calling `.each` on a `nil`.

**Fix this one error and rerun the tests. Repeat until they are all passing!**

### Tips

* You are going to want to convert all of your SQL query results into an
  instance of the correct class. For instance, when you query the database for
  all of the recipes, you don't want to return an array of hashes, you wan't to
  return an array of `Recipe` objects.
* Don't be afraid to open up the test files in `spec/features`. You might
  not be familiar with how to write tests yet but you should be able to get the
  general idea of what they're doing.
