We're going to work on changing a Sinatra application from using hard coded hashes as it's data source to using a PostgreSQL database with Active Record.

Active Record provides an interface for interacting with your database and converting your results directly into Ruby objects.

### Getting Started

Clone and open the contact manager app:

```no-highlight
$ git clone git@github.com:LaunchAcademy/contact_manager.git
$ cd contact_manager
$ bundle install
$ ruby app.rb
```

The web application should now be running at [http://localhost:4567][localhost].

### Setting Up Active Record in Your Sinatra App

#### 1. Add gems

In order to get Active Record working with Sinatra, we're going to use the **`sinatra-activerecord`** gem.

Add the following gems to your Gemfile:

```ruby
gem 'sinatra-activerecord'
gem 'pg'
gem 'rake'
```

Don't forget to run `bundle install` and restart your server.

Now require sinatra/activerecord in your Sinatra application file:

```ruby
# app.rb
require "sinatra/activerecord"
```

#### 2. Add database configuration file

Configure your database by creating a new file called `config/database.yml` containing the following:

```no-highlight
# Configure the database used when in the development environment
development:
  adapter: postgresql
  encoding: unicode
  database: contact_manager_development
  pool: 5
  username:
  password:

# Configure the database used when in the test environment
test:
  adapter: postgresql
  encoding: unicode
  database: contact_manager_test
  pool: 5
  username:
  password:

# Configure the database used when in the production environment
production:
  adapter: postgresql
  encoding: unicode
  database: contact_manager_production
  pool: 5
  username:
  password:
```

#### 3. Create a Rakefile

`sinatra-activerecord` also gives us a bunch of rake tasks that allow us to create our database, add/drop tables, etc. Rake tasks are basically just Ruby scripts that you can run from the command line.

Require the rake tasks by creating a `Rakefile` in the root directory of your app containing the following:

```ruby
# Rakefile
require "./app"
require "sinatra/activerecord/rake"
```

#### 4. Set up the database

We can finish our database setup by using a rake task to actually create our database.

Enter the following command in your terminal:

```no-highlight
rake db:create
```

When we run this rake task, Active Record will look at the `config/database.yml` file to determine what kind of database we want to use, how to talk to it, and how to create it.

---

That's it! If you didn't see any errors, you've got your Sinatra app ready to store data in a database the same way that Rails does.

**Protip: You can see all of the rake tasks that are available to you by using the `rake -T` command on the command line.**

### Creating the Contacts Table

Active Record uses [migrations][migrations] to create and modify tables in the database. Migrations allow us to create our tables using Ruby code.

We can create a migration file by using the `db:create_migration` rake task given to us by `sinatra-activerecord`.

Create a migration that will create a "contacts" table with the following command in your terminal:

```no-highlight
rake db:create_migration NAME=create_contacts
```

By running the previous rake task we've generated a `db/migrate` directory for our app. Inside of that directory you should see a file named something like `20140314134004_create_contacts.rb`. Your actual file name will be slightly different because the first part (the numbers) is actually a timestamp, indicating when you created the file, which is used to make sure that our migrations run in the order that we create them.

Modify your `...create_contacts.rb` migration file so that it looks like this:

```ruby
class CreateContacts < ActiveRecord::Migration
  def change
    # Create the contacts table with the following
    create_table :contacts do |table|
      # A column first_name of type string
      table.string :first_name

      # A column last_name of type string
      table.string :last_name

      # A column phone_number of type string
      table.string :phone_number
    end
  end
end
```

What does it mean to "run" your migrations? Your migration files define **how** to create/remove/modify the tables and table columns in your database. Simply creating the migration file doesn't actually perform any of those actions, they're just instructions for how to do so once we decide that we want to.

When we're done writing our migration file, we can then "run" our migration by using the following rake task:

```no-highlight
rake db:migrate
```

You should see output similar to this:

```no-highlight
==  CreateContacts: migrating =================================================
-- create_table(:contacts)
   -> 0.0095s
==  CreateContacts: migrated (0.0096s) ========================================
```

When we run this rake task, Active Record runs the ruby code in any of the migration files that are prefixed with a timestamp later than the version timestamp in your `db/schema.rb` (the `db/schema.rb` file is created when you run your first migration). This is important because we don't want to rerun any migrations that we have already run in the past.

Before moving on, it's good practice to make sure that your migration can be rolled back. Rolling back a migration is basically like hitting the undo button. Active Record is pretty good at guessing what to do in order to undo our `create_table` because the opposite is to simply drop the table with `drop_table`. You will eventually run into other situations where you will need to manually define what to do for both migrating "up" and rolling back "down" but we're not going to cover that here.

Make sure that your migration can be rolled back, and then migrate "up" again by running the following commands in the terminal:

```no-highlight
# Roll the database back to where it was before the last migration
rake db:rollback

# Run our migration to create the contacts table again
rake db:migrate
```

### Connecting the Contact Model to the Contacts Table

Now we have a `contacts` table in our database and a `Contact` model in our app (at `models/contact.rb`). However, our `Contact` class isn't yet connected to the `contacts` table.

The first step is to alter our class definition so that our class is [inheriting][inheritance] from `ActiveRecord::Base`:

```ruby
class Contact < ActiveRecord::Base
  # ...omitted
end
```

Inheriting from `ActiveRecord::Base`, gives the `Contact` class all of the methods that are defined in the `ActiveRecord::Base` class.

The next step is to remove our `attr_reader` statements and our `#initialize` method. This is some of the "rails magic" kind of stuff that you hear people talking about. We want to remove that stuff is that because the `ActiveRecord::Base` class already defines an `#initialize` method for us. Our initialize method was expecting a hash with all of the model's attributes as a parameter, which happens to be the same way that `ActiveRecord::Base#initialize` works. Active Record will also create `attr_accessors` for each of the attributes on our model, each of which is a field in the `contacts` table, so we can safely remove our `attr_readers`.

Your `models/contact.rb` should now look like this:

```ruby
class Contact < ActiveRecord::Base
  def name
    [first_name, last_name].join(' ')
  end
end
```

Since `ActiveRecord::Base#initialize` works the same way that our `Contact#initialize` method was working, our app should still be working.

**Before continuing, make sure that the app is still working by opening the index page in your browser.** (Make sure you've restarted your server after adding the `sinatra-activerecord` gem.)

### Querying the Database for Contacts

It's great that our app is still working but it's also still creating our
`Contact` objects by reading their information from the hash. It would be better
if we were reading the information for our contacts out of the database.

In `app.rb`, **remove the `before` block** and modify the index action so that it
uses `Contact.all` to retrieve all of the contacts form the database:

```ruby
get '/' do
  @contacts = Contact.all
  erb :index
end
```

Here we're using the `.all` class method that Active Record gives us. `.all` is one of the many methods that make up the [Active Record Query Interface][active-record-query-interface].

`Contact.all` will produce a SQL query that looks like this:

```no-highlight
SELECT "contacts".* FROM "contacts"
```

Active Record will take the results of this query and, based on naming conventions and our table being named `contacts`, create an instance of `Contact` for each row that is returned. It will also define accessor methods for each of the columns, based on the column name.

**Open the index page in your browser. What's wrong?**

### Writing a Seeder

You're right! Our contacts table in the database is empty. We can populate our database using a **seeder**, a file containing code that, when run, will add records to our database table.

Create a `db/seeds.rb` file with the following:

```ruby
contact_attributes = [
  { first_name: 'Eric', last_name: 'Kelly', phone_number: '1234567890' },
  { first_name: 'Adam', last_name: 'Sheehan', phone_number: '1234567890' },
  { first_name: 'Dan', last_name: 'Pickett', phone_number: '1234567890' },
  { first_name: 'Evan', last_name: 'Charles', phone_number: '1234567890' },
  { first_name: 'Faizaan', last_name: 'Shamsi', phone_number: '1234567890' },
  { first_name: 'Helen', last_name: 'Hood', phone_number: '1234567890' },
  { first_name: 'Corinne', last_name: 'Babel', phone_number: '1234567890' }
]

contact_attributes.each do |attributes|
  contact = Contact.new(attributes)
  contact.save
end
```

The `db/seeds.rb` file is another one of those kind of magic parts of Active Record. Remember those rake tasks that Active Record is giving us, that allow us to run bits of Ruby code? `rake db:seed` is one of them. This rake task will look for a `db/seed.rb` file and run the code that we write inside of it.

The `db/seeds.rb` file is a good place to write code that populates your database with some records. In our case, we're using that same hash of data to create a new instance of `Contact`, followed by using `Contact#save` to save all of the contacts attributes into the database. `save` is another one of the methods that we get for free from Active Record.

We can even simplify our seed code by using `Contact.create` instead of `Contact.new`:

```ruby
contact_attributes.each do |attributes|
  Contact.create(attributes)
end
```

`Contact.create` will both create a new instance of `Contact` and save it to the database.

### Seeding the Database

To put our seed code into action, run `rake db:seed`. This will run all of the code we wrote in `db/seeds.rb`.

**You should now be able to view all of the contacts again on the index page.**

### Run the Tests

If you run `rspec spec`, you should see that all of our tests are still passing.

### Add a Contacts `show` page

Your turn to build a page!

Create a `show` page that displays the information for each contact in the database. Users should be able to navigate to `/contacts/:id` to see the information for the contact with the given ID.

**Hint:** Check out the documentation for Active Record on [RailsGuides](http://guides.rubyonrails.org/active_record_querying.html) to learn more about the methods Active Record provides for querying the database.

### Additional Challenges

For an additional challenge:

1. Add pagination to the contacts index page (Hint: check out the Active Record `limit` and `offset` methods).
2. Add a search functionality so users can search for a contact by first and last name (Hint: check out Active Record's `where` method).
3. Add a page where users can add new contacts to the database.

[localhost]: http://localhost:4567
[migrations]: http://guides.rubyonrails.org/migrations.html#creating-a-migration
[inheritance]: http://rubylearning.com/satishtalim/ruby_inheritance.html
[active-record-query-interface]: http://guides.rubyonrails.org/active_record_querying.html#retrieving-multiple-objects
