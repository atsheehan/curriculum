---
title: Introduction to Rails Validations
author: dpickett
complexity_score: 2
scope: core
type: project
group_type: individual
time_estimate: 180
tags: rails, validations
---

### Contents

In this assignment, you'll use **validations** as a way to ensure that only valid data makes its way into our database.

### Learning Goals

* Ensure that data stored in records is of valid type
* Examine the effect that enforced datatypes has on our code

### Resources

* [Rails Guides Covering Validation](http://guides.rubyonrails.org/active_record_validations.html)
* [Rails Documentation on Validations](http://api.rubyonrails.org/classes/ActiveModel/Validations.html)

### Implementation Notes

#### Getting Started

We'll be returning to our music app that we've used in previous assignments. If you don't yet have the app locally, you can set it up by running:

```bash
git clone https://github.com/LaunchAcademy/music.git

# navigate to the "rails root"
cd music

# install dependencies
bundle

# create the schema
rake db:migrate

# build sample data set
rake db:seed
```

#### What are validations?

**Validations** are checks that we put in place in our Rails applications to make sure that only valid data is saved to our database.

Validations happen at two levels: the database level and the model level. **Database-level validations** are added in our migrations. For example, we might add `null: false` or uniqueness constraints to particular fields:

```ruby
class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name, null: false # add null: false constraint

      t.timestamps
    end

    add_index :categories, :name, unique: true # add uniqueness constraint
  end
end
```

Database-level validations are generally sufficient to prevent bad data from making its way into our database. However, they don't provide feeback to users on whether or not the data they've provided (in a form, for example), is valid.

We use **model-level validations** in part so that we can provide error messages to the user. Rails provides [validation helpers](http://guides.rubyonrails.org/active_record_validations.html#validation-helpers) to let us easily add validations to our models. To add `null: false` and uniqueness constraints to our `Category` model, we could write the following:

```ruby
class Category < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
end
```

In most contexts, and for the remainder of this assignment, we'll use **validation** to refer to **model-level validations**.

#### Validation helpers

Validation helpers provide a powerful way for Rails models to ensure that various requirements for data are met. Commonly-used validation helpers include:

* **presence** - disallows null values or empty strings for a given attribute
* **uniqueness** - ensures that only unique values are allowed for a given attribute
* **numericality** - ensures that values contain only the digits 0 through 9
* **format** - checks that values conform to a particular format
* **inclusion** - checks that the value for an attribute is included in some set of pre-determined values.  For example:

```ruby
validates :day, inclusion: { in: ["Sun", "Mon.", "Tues.", "Wed.", "Thurs.", "Fri.", "Sat."] }
```

To learn more about validation helpers and their syntax, check out the Rails guides [here](http://guides.rubyonrails.org/active_record_validations.html#validation-helpers).


#### When do validations take place?

Any time you call one of the following ActiveRecord methods on an object, Rails will run any validations that you may have against the object.

* `create`
* `save`
* `update`
* `update_attributes`

Under the hood Rails will call the `valid?` method on the object and will return true or false based on whether the object is valid or not. If it returns true, all is right with the world and Rails will attempt to save your object to the database.

**Note:** If you call `valid?` directly on an object, Rails will not try to save it to the database but will instead return true or false based on the result of running the validations against the object. This comes in handy if you're trying to create objects in the `rails console`.

There are some methods that can be called on an object that will cause it to skip over the validations and save it to the database directly but these should be avoided at all costs and on pain of death.

**A cautionary note on validations:** Just because Rails reports that an object is valid is no guarantee that it will successfully save to the database. If you have database constraints that aren't met by the object you are attempting to save then the database will raise an error.

This is an important concept that can be confusing: **Validations take place at both the Rails application level and at the database level.** The validations you set in your models - using `validates :field_name, presence: true` and the like - take place at the Rails application level. Validations or constraints that you set in your migrations - `null: false` or `unique: true`, for example - take place at the database level. Normally your model validations will mirror your database constraints (you'll have both a `NOT NULL` constraint and a presence validation, for instance), but it's important to understand that there are two separate validation processes going on and occasionally one may succeed while the other fails.

One other thing to note about validations. It's possible to have validations that are run only against certain actions. For instance, if we only wanted to validate the presence of something on its creation we could do something like:

```ruby
validates :awesomeness, presence: true, on: :create
```

#### Uniqueness Validations and Race Conditions

We sometime want a field in our database to be unique. Say, for example, we have an application where we let a user add coffee to our infamous cash register. We would want each SKU to be unique, so that no two products can have the same SKU. This would best be accomplished with a uniqueness validation. An example of this for our `Coffee` would look like this:

```ruby
class Coffee < ActiveRecord::Base
  validates :sku, uniqueness: true
end
```
This will ensure that rails will only allow a SKU to be assigned to a single coffee in the database. However, this does not validate uniqueness at the database layer, so a race condition can result in identical SKUs being saved to the database. A race condition could occur if two processes are simultaneously trying to write to the database, and they both complete their uniqueness check before either record gets saved to the database. A great example of race conditions as it applies to uniqueness is supplied [here](http://robots.thoughtbot.com/the-perils-of-uniqueness-validations).

To prevent a race condition from occurring, we would add an index to our database to ensure uniqueness. In the case of our Coffee class we would add an index with the following migration:

```ruby
class AddSKUIndexToCoffee
  def change
    add_index :coffee, :sku, unique: true
  end
end
```
This will ensure that the database performs a uniqueness check on the SKU. For a more detailed look at uniqueness validations and the options that are available to them, view the [uniqueness docs](http://edgeguides.rubyonrails.org/active_record_validations.html#uniqueness) for ActiveRecord.

#### Practice Time!

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

Once this is done, open up the `rails console` and try the following:

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

Rails encountered your validation and refused to save the change you made that set `year` equal to `nil`. When you now retrieve the year from the last song, you should see that it is unchanged:

```ruby
2.0.0-p353 :005 > Song.last.year
  Song Load (0.3ms)  SELECT "songs".* FROM "songs" ORDER BY "songs"."id" DESC LIMIT 1
 => 1953
 ```

**Note**: The rails console requires a restart to register changes to model classes' validations. If you made another change to the validations in your `Song` class, you'd need to restart the rails console to see them take effect. You can also try to use `reload!`.

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

{% quick_challenge %}
**Quick Challenge:** With a new song, using `new`, not `create`, set a value for the year that is invalid. Prior to saving, call the `valid?` method on your song. What do you learn? How might this be useful?
{% endquick_challenge %}

**Note**: Validations can become quite complex. At times, including `valid?` checks on your new objects can be a useful way to branch to code that deals with this condition.

**Note**: The ActiveRecord `create` methods calls the `new` and `save` methods. Separating `new` and `save`, instead of using `create`, allows the management of error conditions that could cause the creation of a new record to fail. This is a result of the ORM characteristic of separating the representation from the record in the database it represents.

In our example above, we focused on the length of a year. This is a well-defined condition: in normal use we can be pretty certain that we won't encounter years that are 5 digits long and it's standard to require 4-digit years. In a recorded songs database these conditions are pretty much certain to be true.

{% quick_challenge %}
**Quick Challenge:** Rails' ActiveModel class provides validation helpers. Can you find a way to refactor our `:minimum => nn, :maximum => nn` syntax to something more terse? Refer to the documentation for ActiveModel's validation helpers.
{% endquick_challenge %}

---

{% quick_challenge %}
**Quick Challenge:** Rewrite the song model class to include validations for all of the fields that you have included (i.e., not the columns that Rails provided on its own such as timestamps). Use the example of the `year` column as a starting point. For the 3 string fields, set limits on minimum and maximum length that you think will be reasonable. Ensure that the value given for years is a number. Consider what you might do if a user tries to add a record without knowing some information, e.g. the label of the album.
{% endquick_challenge %}

**Hint**: You cannot complete this without reference to the appropriate documentation for Rails.

### Rules to Follow

#### Use validations as a means to require quality data as input to your application

Validations help to prevent the phenomenon of [garbage in garbage out](http://en.wikipedia.org/wiki/Garbage_in_garbage_out). By requiring data to adhere to certain standards before it is written to the database, we can ensure that only quality data is stored within it.

#### Include validations at both the database and the model levels

Incorporating validations at both levels allows us to test whether a record is valid before writing it to the database, provide useful error messages to our users, and prevent errors due to race conditions.

### Why This is Important

#### Enforcing Datatypes is important to consistent applications.

The Rails validation process and the accompanying validation helpers are the primary way to ensure that your data maintains integrity. Consistent data across many records allows simpler, easier to maintain code. Uniqueness validations are an important edge case to be mindful of, and creating indexes helps enforce data consistency.
