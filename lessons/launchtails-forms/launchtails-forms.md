## How can I find drinks that are shaken, not stirred?

We're already making the world a better place by disrupting the space-themed drink industry. 
Since we just closed $4.2MM worth of funding at at $25MM valuation, we can invest further in our product development!

The product manager has asked for us to keep track of additional information pertaining to each drink. 
In this challenge, you'll work to enhance what we track for each drink that is added to the system.

## Instructions

1. Clone the [repository][launchtails-gh] if you haven't already
2. `cd` into the directory, run `bundle && rake db:create db:migrate db:test:prepare`
3. Switch to the `forms` branch. It's recommended you start with a clean github state. 
  Switch with the following command line command: `git fetch origin && git checkout -b forms --track origin/forms`
4. Run the test suite via `rake spec`. There are a series of new features we must add to the new Drink form.

## Tips and More Detail

* We have supplied a seed file for you. 
  Running `rake db:seed` will supply featured and nonfeatured drinks in your development environment.
* Run `rails server` in your terminal to run the web server.
* We've created some files already for you.
* You will have to modify **both** the view and the controller to ensure the additional fields are populated.

## Noncore Challenge

* Follow the practice of outside in development to allow for the creation of new categories. 
  You will need a feature spec, view and a new controller, at a minimum. Be sure to utilize the `form_for` 
  Rails helper when creating the form to add a new category.
* Create a means to identify a list of traits for a given drink. 
  For example, I could specify an Irish coffee to have hot, Irish, and cultural characteristics.
  You should utilize a `has_many :through` association and the `collection_check_boxes` view helper.
  You should also modify `db/seeds.rb` to create a list of characteristics that drinks can have.

[launchtails-gh]: https://github.com/LaunchAcademy/launchtails
