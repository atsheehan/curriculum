In this assignment we'll use **validations** as a way to ensure that only valid data makes its way into our database.

### Learning Goals

* Ensure that data stored in records is of valid type
* Examine the effect that enforced datatypes has on our code

### Sample Application

In the `sample-code` folder, we have a Sinatra app that includes the Sinatra ActiveRecord Extension gem. We have included a `Song` model, along with a seed script to add songs to the database. Run the following commands to get started:

```ruby
# download this assignment, if you haven't already
$ et get activerecord-validations

# navigate into the sample-code folder
$ cd activerecord-validation/sample-code

# install dependencies
$ bundle

# create the database, create the schema, and seed the database
$ rake db:create
$ rake db:migrate
$ rake db:seed
```

### What Are Validations?

**Validations** are checks that we put in place in our applications to make sure that only valid data is saved to our database.

Validations happen at two levels: the database level and the model level. **Database-level validations** are added in our migrations. For example, we might add `null: false` or uniqueness constraints to particular fields:

```ruby
class CreateGenres < ActiveRecord::Migration
  def change
    create_table :genres do |t|
      t.string :name, null: false # add null: false constraint

      t.timestamps null: false
    end

    add_index :genres, :name, unique: true # add uniqueness constraint
  end
end
```

Database-level validations are generally sufficient to prevent bad data from making its way into our database. However, they don't provide feeback to users on whether or not the data they've provided (in a form, for example), is valid.

We use **model-level validations** in part so that we can provide error messages to the user. ActiveRecord provides [validation helpers](http://guides.rubyonrails.org/active_record_validations.html#validation-helpers) to let us easily add validations to our models. To add constraints checking for a non-empty, unique value to our `Category` model we could write the following:

```ruby
class Genre < ActiveRecord::Base
  validates :name, presence: true
  validates :name, uniqueness: true
end
```

In most contexts and for the remainder of this article, we'll use **validation** to refer to **model-level validations**.

#### Validation Helpers

Validation helpers provide a powerful way for ActiveRecord models to ensure that various requirements for data are met. Commonly-used validation helpers include:

* **presence** - disallows null values or empty strings for a given attribute
* **uniqueness** - ensures that only unique values are allowed for a given attribute
* **numericality** - ensures that values contain only the digits 0 through 9
* **format** - checks that values conform to a particular format using regular expressions
* **inclusion** - checks that the value for an attribute is included in some set of pre-determined values.  For example:

```ruby
validates :day, inclusion: { in: ["Sun", "Mon.", "Tues.", "Wed.", "Thurs.", "Fri.", "Sat."] }
```

To learn more about validation helpers and their syntax, check out the ActiveRecord documentation [here](http://guides.rubyonrails.org/active_record_validations.html#validation-helpers).

#### When Do Validations Take Place?

Any time you call one of the following ActiveRecord methods on an object, validations will be checked for that object.

* `create`
* `save`
* `update`
* `update_attributes`

Under the hood, ActiveRecord will call the `valid?` method on the object and will return true or false based on whether the object is valid or not. If it returns true, all is right with the world and ActiveRecord will attempt to save your object to the database.

**Note:** If you call `valid?` directly on an object, ActiveRecord will not try to save it to the database but will instead return true or false based on the result of running the validations against the object. This comes in handy if you're trying to create objects in the `pry` or `irb` console.

There are some methods that can be called on an object that will cause it to skip over the validations and save it to the database directly but these should be avoided at all costs!

**A cautionary note on validations:** Just because ActiveRecord reports that an object is valid, it is not guaranteed that it will successfully save to the database. If you have database constraints that aren't met by the object you are attempting to save then the database will raise an error.

This is an important concept that can be confusing: **Validations take place at both the application level and at the database level.** The validations you set in your models - using `validates :field_name, presence: true` and the like - take place at the application level. Validations or constraints that you set in your migrations - `null: false` or `unique: true`, for example - take place at the database level. Normally your model validations will mirror your database constraints (you'll have both a `NOT NULL` constraint and a presence validation, for instance), but it's important to understand that there are two separate validation processes going on and occasionally one may succeed while the other fails.

One other thing to note about validations. It's possible to have validations that are run only against certain actions. For instance, if we only wanted to validate the presence of something on its creation we could do something like:

```ruby
validates :genre, presence: true, on: :create
```

#### Uniqueness Validations and Race Conditions

We sometime want a field in our database to be unique. Say, for example, we let a user add a new album to our application. We would want each album SKU to be unique, so that no two albums can have the same SKU. This would best be accomplished with a uniqueness validation. An example of this for our `Albums` model, would look like this:

```ruby
class Albums < ActiveRecord::Base
  validates :sku, uniqueness: true
end
```

**Note:** You should not implement this example. We have not provided any SKUs in the seed file.

This uniqueness validation will ensure that ActiveRecord will only allow a SKU to be assigned to a single album in the database. However, this does not validate uniqueness at the database layer, so a race condition can result in identical SKUs being saved to the database. A race condition could occur if two processes are simultaneously trying to write to the database, and they both complete their uniqueness check before either record gets saved to the database. A great example of race conditions as it applies to uniqueness is supplied [here](http://robots.thoughtbot.com/the-perils-of-uniqueness-validations).

To prevent a race condition from occurring, we would add an index to our database to ensure uniqueness. In the case of our Album class we would add an index with the following migration:

```ruby
class AddSKUIndexToAlbum < ActiveRecord::Migration
  def change
    add_index :albums, :sku, unique: true
  end
end
```
This will ensure that the database performs a uniqueness check on the SKU. For a more detailed look at uniqueness validations and the options that are available to them, view the [uniqueness docs](http://edgeguides.rubyonrails.org/active_record_validations.html#uniqueness) for ActiveRecord.

### Practice Time!

Open up your `Song` model in the music project. First, let's add a validation that will prevent null values from being accepted for the `:year` attribute. Inside the class, add a line return and on the line after add this:

```ruby
validates :year, presence: true
```

Your song class now looks something like this:

```ruby
class Song < ActiveRecord::Base
  validates :year, presence: true
end
```

Once this is done, open up this app in the console by typing `pry -r './server.rb'` at the terminal, and try the following:

```ruby
s = Song.last
s.year = nil
s.save
```

What is the result? What did you expect it to be? If you now retrieve the last song record, what is the value of the year column?

You should have seen something like the following when you called `s.save`:
```ruby
  (0.1ms)  rollback transaction
=> false
```

ActiveRecord encountered your validation and refused to save the change you made that set `year` equal to `nil`. When you now retrieve the year from the last song, you should see that it is unchanged:

```ruby
[1] pry(main)> Song.last.year
D, [2015-03-05T16:40:12.485423 #15836] DEBUG -- :   Song Load (1.4ms)  SELECT  "songs".* FROM "songs"  ORDER BY "songs"."id" DESC LIMIT 1
=> 2011
 ```

**Note**: The pry console requires a restart to register changes to model classes' validations. If you made another change to the validations in your `Song` class, you'd need to restart the pry console to see them take effect. You can also try to use `reload!`.

Provide a value for the year column and try to save the song. Test what happens with values that are strings. What about the integer zero?

Now let's modify our validation to ensure that only 4-digit years are allowed. Try adding this to your `Song` class:

```ruby
validates :year, numericality: true, length: { is: 4 }
```

Test your `Song` class again, this time by entering a year in the form **1977**. What happens if you actually type an extra digit and try to save? What happens if you enter the year in abbreviated form, i.e. **77**? Does this align with your expectations?

Let's say we also want to allow 2-digit years. We can replace the `is: 4` clause in our `length` validation with `minimum: 2, maximum: 4`.

Restart the console and test again. What do you find with short year formats?

---

This demonstrates that validations can have multiple conditions that must be met for the record to be valid. At times, we may not be certain that we've met those conditions prior to trying to save. To check, we can call `valid?` on an object before saving. We can also call the `errors` method on a record prior to saving to list any errors raised by our validations.

**Quick Challenge:** With a new song, using `new`, not `create`, set a value for the year that is invalid. Prior to saving, call the `valid?` method on your song. What do you learn? How might this be useful?

**Note**: Validations can become quite complex. At times, including `valid?` checks on your new objects can be a useful way to branch to code that deals with this condition.

**Note**: The ActiveRecord `create` methods calls the `new` and `save` methods. Separating `new` and `save`, instead of using `create`, allows the management of error conditions that could cause the creation of a new record to fail. This is a result of the ORM characteristic of separating the representation from the record in the database it represents.

In our example above, we focused on the length of a year. This is a well-defined condition: in normal use we can be pretty certain that we won't encounter years that are 5 digits long and it's standard to require 4-digit years. In a recorded songs database these conditions are pretty much certain to be true.

**Quick Challenge:** The ActiveModel class provides validation helpers. Can you find a way to refactor our `minimum: x, maximum: y` syntax to something more terse? Refer to the documentation for ActiveModel's validation helpers.

**Quick Challenge:** Rewrite the `Song` model to include validations for all of the fields that you have included (i.e., not the columns that ActiveRecord provided on its own such as timestamps). Use the example of the `year` column as a starting point. For the string fields, set limits on minimum and maximum length that you think will be reasonable. Ensure that the value given for years is a number. Consider what you might do if a user tries to add a record without knowing some information, e.g. the label of the album.

**Hint**: You cannot complete this without reference to the appropriate documentation for ActiveRecord.

### Resources

* [ActiveRecord Validations - RailsGuides](http://guides.rubyonrails.org/active_record_validations.html)
* [Rails Documentation on Validations](http://api.rubyonrails.org/classes/ActiveModel/Validations.html)

### In Summary

The ActiveRecord validation process and the accompanying validation helpers are the primary way to ensure that your data maintains integrity. Consistent data across many records allows simpler, easier to maintain code. Uniqueness validations are an important edge case to be mindful of, and creating indexes helps enforce data consistency.
