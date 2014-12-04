In the [Lunar Kitchen I][lunar-kitchen-i] challenge you implemented the `.all` and `.find` methods for the Recipe class. In this challenge, you'll convert the Lunar Kitchen app to use ActiveRecord, which provides a whole slew of methods for querying the database, including `.all` and `.find` methods.

### Instructions

Following the example in the [Contact Manager][contact-manager] tutorial, add Active Record and convert the `Recipe` and `Ingredient` models to use Active Record.

This application reads from the `recipes` database. If you don't already have this database created, run the following commands to do so:

```no-highlight
$ createdb recipes
$ psql recipes < recipes_database.sql
```

This application also has an accompanying test suite. To run the test suite you'll need to install a few gems which are specified in the `Gemfile`. To install them, run the following command:

```no-highlight
$ bundle install
```

**Note:** If the `bundle` command is not found, run `gem install bundler` first.

### Hints

* You do not need to add an `id` field to a table in your migrations.  Active Record will automatically do that for you. As an example, your migration to create the recipes table should look something like:

```ruby
class CreateRecipes < ActiveRecord::Migration
  def change
    create_table "recipes", force: true do |t|
      t.string :name
      t.string :description
      t.string :instructions
    end
  end
end
```

* ActiveRecord will create getter and setter methods for all the fields in your `recipes` database table automatically.  For attributes that *don't* correspond to a field on the `recipes` table, such as a `Recipe`'s `ingredients`, ActiveRecord uses [associations][associations] to create getters and setters:

```ruby
# models/recipe.rb
class Recipe < ActiveRecord::Base
  has_many :ingredients
  # ...
end

# models/ingredient.rb
class Ingredient < ActiveRecord::Base
  belongs_to :recipe
  # ...
end
```

The code above will allow you to call `.ingredients` on a recipe and retrieve an array (or, more specifically, an `ActiveRecord::Relation` object, which behaves much like an array) of ingredient objects with that recipe's ID. Similarly, calling `.recipe` on an ingredient will return the recipe object that that ingredient belongs to.

[lunar-kitchen-i]: /lessons/sinatra-lunar-kitchen
[contact-manager]: /lessons/contact-manager
[associations]: http://guides.rubyonrails.org/association_basics.html
