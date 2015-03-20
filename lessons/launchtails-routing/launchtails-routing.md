## Enough Brussel Sprouts! I need a drink!

We're building a new Rails app. We want to feature our favorite, space themed drinks for everyone to enjoy! Thankfully, we have a [starting point already on GitHub][launchtails-gh], but the team lead has left a few things for you to do!

## Instructions

1. Clone the [repository][launchtails-gh]
2. `cd` into the directory, run `bundle && rake db:create db:migrate db:test:prepare`
3. Run the test suite via `rake spec`. There are a series of acceptance tests that will require you to make some changes to the application. **DO NOT CHANGE THE TESTS**.

## Tips and More Detail

* We have supplied a seed file for you. Running `rake db:seed` will supply featured and nonfeatured drinks in your development environment.
* Run `rails server` in your terminal to run the web server.
* We've created some files already for you.
* For creating and listing drinks, modify your `config/routes.rb` to refer to the `DrinksController`. Be sure to restrict your routes so that editing and updating is not possible.
* For deleting drinks, we've left the implementation up to you. Define and implement the appropriate method in `DrinksController`.
* For listing featured drinks, we've created the appropriate controller and view for you. Implement the appropriate controller method and routing to feed the view with the intended data in order to get the tests in `spec/features/visitor_views_featured_drinks_spec.rb` to pass.
* Map the root so that when I navigate to '/', I see a list of featured drinks.

## Noncore Challenge

* The controllers, views, and acceptance tests do not currently make use of named routes. Refactor these files so that they make use of `*_path` helpers that point to the appropriate URL's.

[launchtails-gh]: https://github.com/LaunchAcademy/launchtails
