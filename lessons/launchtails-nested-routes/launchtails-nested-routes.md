## The drink made just for you!

Good news! Elon Musk was so in love with our pitch of a strategic partnership between SpaceX
and our Drink finding app that he wants to buy the company.

There are few features that he has requested before he sends us an offer for
$100MM.

He's requesting that you be able to view drinks by category, and for a way for
admins to edit existing drinks.

## Instructions

1. Clone the [repository][launchtails-gh] if you haven't already.
2. `cd` into the directory.
3. Switch to the `nested-routes` branch. It's recommended you start with a clean github state. 
  Switch with the following command line command: `git fetch origin && git
  checkout -b nested-routes --track origin/nested-routes`.
4. run `bundle && rake db:create db:migrate db:test:prepare`.
5. Run the test suite via `rake spec`. 
  There are a series of new features we must add in order to get the tests to
  pass. You should not have to modify the test suite in order to fulfill the
  requirements needed to get the tests to pass.

## Tips and More Detail

* We have supplied a seed file for you. 
  Running `rake db:seed` will supply featured and nonfeatured drinks in your development environment.
* Run `rails server` in your terminal to run the web server.
* We've created some files already for you.
* Utilize nested routes to build the `/categories/<category_id>/drinks` URL and
  functionality. You can either introduce flow control in your
  `DrinksController` to check for the existance of `params[:category_id]`, or
  you can create an entirely new controller.
* Utilize namespaced routes for the `admin` section. Be sure to restrict routes
  so that only `edit` and `update` are available in the `admin` namespace.
* Do not worry about authorization (checking to see if the user is an admin) in the admin namespace. 
  Someone else will ensure those URL's are protected and that only admins can modify drinks.

## Noncore Challenge

* Utilize a partial to keep our new and edit drink forms DRY
* Create an admin section where I can update category names. Again, do not worry
  about authorization (checking to see if a user is an admin).

[launchtails-gh]: https://github.com/LaunchAcademy/launchtails
