In this article we'll discuss how to use FactoryGirl to quickly setup database records for testing.

### Learning Goals

* Refactor test code
* Define and use a factory
* Create multiple records at once from a factory
* Define and use a factory sequence

### Isolating Tests

Each test we write for our application should work in isolation. We don't want the changes in one test to affect the outcome of another test. This makes it much simpler to test behavior without worrying about other tests that have come before or after.

The problem with this approach is that to test any sort of interesting behavior we'll often need to run extensive amounts of setup to get our environment to simulate those conditions. For example, if we were testing a review site like Yelp and wanted to test that a web page lists all of a user's reviews, we'd need to create a user, some reviews and the places that they reviewed just for a single test. When we have a whole test suite, the amount of time we spend setting up our environments can quickly outpace the amount of time spent testing interesting behavior.

We can simplify our lives by using predefined **factories** that will create records for a model with some generic attributes. In addition to defining generic attributes, it can also be used to create any associated objects for us that are required for validations but not really pertinent to the test itself.

### Setup

For this article we'll use a recipe application to demonstrate how FactoryGirl works. Let's start with a new Rails application:

```no-highlight
$ rails new recipes --database=postgresql --skip-test-unit
$ cd recipes
$ git init
$ git add -A
$ git commit -m 'Initial commit'
```

This will create a new Rails application _without_ the default test directories and configured to use PostgreSQL. Once the application is ready, we'll change into the directory, initialize a git repository and record our first commit.

Now let's setup our application for RSpec and FactoryGirl. Add the following code to the end of the `Gemfile` (located in the root of the application):

```ruby
group :test, :development do
  gem "rspec-rails"
  gem "factory_girl_rails"
end
```

This will include the `rspec-rails` and `factory_girl_rails` gems when we're working in the test and development environments. After saving this file, run the following commands:

```no-highlight
$ bundle
$ rails generate rspec:install
$ git add -A
$ git commit -m 'Add gems for testing'
```

The `bundle` command will fetch our new gems and include them in our project. We can then run a Rails generator that will install the RSpec configuration files. Once this is complete, we stage the files using `git add -A` and create a new commit to store our changes.

Now, let's add our model that we'll be testing with the following command:

```no-highlight
$ rails generate model recipe name:string description:text \
    instructions:text servings:integer cooking_time:integer
```

This will create our model and migration file that we'll use to create the table in our database. Run the following commands to first create and setup our database:

```no-highlight
$ rake db:create
$ rake db:migrate
$ git add -A
$ git commit -m 'Add recipe model'
```

After creating our database, we ran our migrations which created the `recipes` table in our `recipes_development` database. At this point, we should have an application with a single model and a pending RSpec test that was automatically generated for us.

Before we run our test suite, we need to modify the `.rspec` file that is in the root of our Rails application. Remove the `--warnings` line from `.rspec` so that it looks like:

```no-highlight
--color
--require spec_helper
```

Now if we run `rake spec`, we should see the following:

```no-highlight


$ rake spec

*

Pending:
  Recipe add some examples to (or delete) ../recipes/spec/models/recipe_spec.rb
    # Not yet implemented
    # ./spec/models/recipe_spec.rb:4

Finished in 0.00092 seconds (files took 4.34 seconds to load)
1 example, 0 failures, 1 pending
```

Now we can get back to testing...

### Finding Quick Recipes

Let's return to our recipe application and see how we can use FactoryGirl to simplify our tests. Let's add the following validations to our model in `app/models/recipe.rb`:

```ruby
class Recipe < ActiveRecord::Base
  validates :name, presence: true
  validates :instructions, presence: true
  validates :cooking_time, numericality: { greater_than: 0 }
  validates :servings, numericality: { greater_than: 0 }
end
```

Now we want to test-drive a `quick_recipes` method on our `Recipe` class that returns only recipes that have the cooking time of less than 30 minutes. We might start with something like this in our `spec/models/recipe_spec.rb` file:

```ruby
require "rails_helper"

describe Recipe do
  describe ".quick_recipes" do
    it "returns recipes with a cooking time less than 30 min" do

      pb_and_j = Recipe.create!(name: "Peanut Butter & Jelly Sandwich",
        instructions: "blah", cooking_time: 5, servings: 1)
      pot_roast = Recipe.create!(name: "Pot Roast",
        instructions: "blah blah", cooking_time: 240, servings: 12)
      cheerios = Recipe.create!(name: "A Bowl of Cheerios",
        instructions: "bloop", cooking_time: 4, servings: 1)

      results = Recipe.quick_recipes

      expect(results).to include(pb_and_j)
      expect(results).to include(cheerios)

      expect(results).to_not include(pot_roast)
    end
  end
end
```

Here we're testing a method on our `Recipe` model. We first create some sample recipes with varying cooking times and are testing that we only receive the ones that are below a certain threshold.

If we run our test, we'll fail with an `undefined method` error since we haven't yet defined our `quick_recipes` method in the model. We can get our test to pass by implementing the following in `app/models/recipe.rb`:

```ruby
def self.quick_recipes
  where("cooking_time < ?", 30)
end
```

Now, our tests will be green, but there's a lot of noise in our previous spec. Since we have validations on our model, when we create a new `Recipe` record we have to specify the recipe name, the instructions, a cooking time, and the number of servings. For our `quick_recipes` method, we only care about the cooking time yet we have to specify all of the other attributes otherwise our record won't save. Even worse, if we add another required field to the `recipes` table, we'll have to modify all of our `create!` invocations. This requires a lot of maintenance and wasted time.

Ideally, we'd like to be able to write something like:

```ruby
Recipe.create!(cooking_time: 5)
Recipe.create!(cooking_time: 240)
Recipe.create!(cooking_time: 4)
```

We can't do this using the `Recipe.create` method, but we can use FactoryGirl to create generic records with predefined attributes that we'll overwrite as needed.

### Defining Our Factories

FactoryGirl is a gem that handles the creation of objects with predefined attributes for testing purposes. Before we can use a factory, we need to define it somewhere. There are a few predefined places that the `factory_girl_rails` gem will check for factory definitions. When we ran our generator for the model it created a new factory file in `spec/factories/recipes.rb`:

```ruby
FactoryGirl.define do
  factory :recipe do
    name "MyString"
    description "MyText"
    instructions "MyText"
    servings 1
    cooking_time 1
  end
end
```

Here they've defined the `:recipe` factory which corresponds with the `Recipe` model. Within the `do..end` block the various attributes that are defined for the model are given default `"MyString"` values. Let's change those to be a little more specific:

```ruby
FactoryGirl.define do
  factory :recipe do
    name "Green Eggs & Ham"
    description "Just what the title says."
    instructions "1. Cook eggs.\n2. Cook ham.\n3. Combine"
    servings 4
    cooking_time 45
  end
end
```

Now that our factory is defined, let's test it out. Open up `rails console` and run the following:

```ruby
> first = FactoryGirl.create(:recipe)
> first.id            # => 1
> first.name          # => "Green Eggs & Ham"
> first.servings      # => 4
> first.cooking_time  # => 45

> second = FactoryGirl.create(:recipe)
> second.id            # => 2
> second.name          # => "Green Eggs & Ham"
> second.servings      # => 4
> second.cooking_time  # => 45
```

Since our `factory_girl_rails` gem was defined in the test _and_ development environment, we're able to use it from the Rails console while in development mode. We first create a new recipe record with `FactoryGirl.create(:recipe)`. This will look up the factory we had defined earlier, create a new `Recipe` object, set the various attributes we had defined and save it to the database. When we inspect each of the attributes, we should see that they are the same values that we had defined in our `spec/factories/recipe.rb` file.

A factory is really just a template for churning out objects. A factory wouldn't really be that useful if it can only create one object per definition, so when we call `FactoryGirl.create(:recipe)` again it creates a new record with the same attributes that we had specified earlier. We can see that the database assigned a new ID to the second object which differentiates it from the previous one.

Right now, we can create lots of recipes for Green Eggs and Ham. This is nice but not all that useful for our tests. We need to be able to create different types of recipes. FactoryGirl let's us _overwrite_ individual attributes when we're creating the object so that we can tailor them to our needs. Try the following in the Rails console:

```ruby
> pot_roast = FactoryGirl.create(:recipe, name: "Pot Roast")
> pot_roast.name          # => "Pot Roast"
> pot_roast.servings      # => 4
> pot_roast.cooking_time  # => 45
```

Notice how we created a record from the same factory with a different name. In the `create` method we can overwrite the attributes that are relevant to us while keeping all of the other attributes the same. This let's us create objects and focus in on only the attributes that we are trying to test.

We can now go back to our original spec and use FactoryGirl to clean up our object creation:

```ruby
require "rails_helper"

describe Recipe do
  describe ".quick_recipes" do
    it "returns recipes with a cooking time less than 30 min" do
      first_quick_recipe = FactoryGirl.create(:recipe, cooking_time: 5)
      second_quick_recipe = FactoryGirl.create(:recipe, cooking_time: 4)
      long_recipe = FactoryGirl.create(:recipe, cooking_time: 240)

      results = Recipe.quick_recipes

      expect(results).to include(first_quick_recipe)
      expect(results).to include(second_quick_recipe)
      expect(results).to_not include(long_recipe)
    end
  end
end
```

Since we don't care about what the recipe was called or how much it yields, we only need to overwrite the `cooking_time` attribute in our factories. Not only is it less code, it's also clearer to the reader that the relevant attribute is the `cooking_time`. If we run our test suite, we should still have a passing test.

### Multiple Records

In our previous example, we need to create multiple records for different recipes so that we can test the functionality of `quick_recipes`. FactoryGirl provides some methods for creating multiple records with the same attributes via `create_list`. We can rewrite our previous spec to take advantage of this feature:

```ruby
require "rails_helper"

describe Recipe do
  describe ".quick_recipes" do
    it "returns recipes with a cooking time less than 30 min" do
      quick_recipes = FactoryGirl.create_list(:recipe, 2, cooking_time: 5)
      slow_recipes = FactoryGirl.create_list(:recipe, 3, cooking_time: 240)

      results = Recipe.quick_recipes

      quick_recipes.each do |quick_recipe|
        expect(results).to include(quick_recipe)
      end

      slow_recipes.each do |slow_recipe|
        expect(results).to_not include(slow_recipe)
      end
    end
  end
end
```

To setup our records, we call `create_list` and pass in our factory, the number of records to create, and the attributes to override. We're only creating a handful of records here, but for tests that require a large volume of records these methods will becomes very handy.

### Sequences

In some cases we don't want (or can't have) records with identical attributes. For example, a `:user` factory will churn out new users with a generic email and password, but we may have a constraint on our database that prevents two user rows from having the same e-mail address.

One way to solve this problem is by using **sequences** in FactoryGirl. Sequences are used when we need to generate a slightly different value for each subsequent record created. Let's use a sequence to ensure that the `name` attribute is unique for each record created via FactoryGirl:

```ruby
FactoryGirl.define do
  factory :recipe do
    sequence(:name) { |n| "Green Eggs & Ham #{n}" }
    description "Just what the title says."
    instructions "1. Cook eggs.\n2. Cook ham.\n3. Combine"
    servings 4
    cooking_time 45
  end
end
```

Here we changed `name "Green Eggs & Ham"` to `sequence(:name) { |n| "Green Eggs & Ham #{n}" }`. For a sequence we have to specify the name of the attribute and then within a code block (`{..}`) we're given a unique integer that we can do whatever with. In this case, we're substituting the integer within a string to return a unique name each time.

If we open up Rails console, we can test this out:

```ruby
> first = FactoryGirl.create(:recipe)
> first.name    # => "Green Eggs & Ham 1"

> second = FactoryGirl.create(:recipe)
> second.name   # => "Green Eggs & Ham 2"
```

Each time we create a record using the `:recipe` factory, it generates a unique recipe name by passing in a unique integer to the sequence we defined. We can still overwrite the `name` attribute if we wanted as well:

```ruby
> third = FactoryGirl.create(:recipe, name: "Cheerios")
> third.name    # => "Cheerios"
```

### Resources

* [FactoryGirl](https://github.com/thoughtbot/factory_girl)
* [FactoryGirl - Getting Started](https://github.com/thoughtbot/factory_girl/blob/master/GETTING_STARTED.md)

### In Summary

Each test for our application should work in isolation. When the behavior that is being tested requires a lot of setup code we can rely on **factories** to generate predefined objects for us with generic attributes.

**factory_girl** is a Ruby library that allows us to define factories for use within our tests. Each factory has a set of predefined attributes that can be overwritten when necessary. This lets us focus on the attributes that are relevant for the test and use sensible defaults for the rest.

Sometimes our models require an attribute to be unique per record. We can use **sequences** within our factories that will assign a unique ID to an attribute ensuring that there are no duplicates.
