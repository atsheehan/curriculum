In this assignment, you'll work with SQL statements to create databases and define columns, and use ActiveRecord migrations to do the same.

We use [Data Definition Language](https://en.wikipedia.org/wiki/Data_definition_language), or DDL for short, to define schema. It has many variants around a common core of commands that are found in databases like SQLite, Berkeley DB, MySQL and PostgreSQL among the free or open source variants. SQL is also used in many proprietary database management systems, including products by Oracle and Microsoft. Other database systems like MongoDB, Redis, CouchDB and others do not use SQL.

### Learning Goals

* Use SQL to directly create tables and columns
* Generate and run migrations that add or modify columns

### Implementation Notes

Create a directory and move into it. Type:

```no-highlight
createdb songs_db
psql songs_db
```

Pay attention to the output of the `createdb` command. Silence is golden.

Now type the following into `psql`:

```sql
CREATE TABLE songs(id SERIAL PRIMARY KEY, name TEXT, album TEXT, artist TEXT);
\d
\d songs
```

If everything goes well, you will see a new table. Creating a database and a new table in SQL is rather straightforward.

We can perform these same tasks by utilizing Ruby libraries. [ActiveRecord](https://github.com/rails/rails/tree/master/activerecord) and the [Sinatra ActiveRecord Extension](https://github.com/janko-m/sinatra-activerecord) provide us with commands we can use to create a database and create tables in our database.

First, let's exit out of `psql`, wipe out the database we created earlier, and move into the `sample-code` directory:

```no-highlight
\q
dropdb songs_db
cd sample-code
```

Copy the `config/database.example.yml` file to `config/database.yml` and change the name of the database. Your `config/database.yml` file should look like this:

```no-highlight
# Configure the database used when in the development environment
development:
  adapter: postgresql
  encoding: unicode
  database: songs_db
  pool: 5
  username:
  password:
```

Now, from the `sample-code` folder, run the following commands:

```no-highlight
bundle
rake db:create
rake db:create_migration NAME=create_songs
```

The `bundle` command looks at the Gemfile, and installs any gem dependencies that you do not have installed on your system. `rake db:create` is equivalent to the `createdb` command. It looks at the `config/database.yml` file to know what to call the new database. The last command will create a file in the `db/migrate` folder that starts with a timestamp, and ends with `create_songs.rb`. Within this file, we can describe the schema for the songs table. Modify it so the contents look like this:

```ruby
class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.text :name
      t.text :album
      t.text :artist
    end
  end
end
```

Within the change method, we have ruby code that will create a new "songs" table. In order to enact these changes, we must run the migrate command:

```no-highlight
rake db:migrate
```

Try inspecting the database using `psql`:

```no-highlight
psql songs_db
\d
\d songs
```

We have just created a songs table using Ruby! We didn't have to specify an primary key `id` column in our migration. ActiveRecord assumes that we always want an `id` column. This feature of ActiveRecord exemplifies the "convention over configuration" idiom you have been hearing so much about. Pretty neat, right?

---

Just like ActiveRelation and ActiveRecord provide us with means to generate SQL for CRUD operations, the ActiveRecord migration system provides us with means to generate DDL that can affect changes on our schema.

Let's add another table to our application:

```no-highlight
rake db:create_migration NAME="add_genre_to_songs"
```

We should see output like before, a file is created in `db/migrate` with a timestamp and ends with `add_genre_to_songs.rb`. Let's open that file.

```ruby
class AddGenreToSongs < ActiveRecord::Migration
  def change
  end
end
```

As you may have concluded, the `change` method is called when we run the migration using the `rake db:migrate` command. Let's modify this slightly to explore further what happens when you run a migration:

```ruby
class AddGenreToSongs < ActiveRecord::Migration
  def up
  end

  def down
  end
end
```
*Note*: In earlier versions of ActiveRecord, migrations were created with these `up` and `down` methods by default, rather than a single `change` method. We'll discuss the differences below.

Now we have two methods: what are they?

The `up` method is called when a migration is run. Its actions can be undone by **rolling back** the migration. To see the mechanism, try this:

#### migration file:

```ruby
class CreateGenres < ActiveRecord::Migration
  def up
    puts "We migrated! One small step forward."
  end

  def down
    puts "Abort! Rolling Back!"
  end
end
```

#### Terminal:

```no-highlight
rake db:migrate
rake db:rollback
```

While migration files can seem mystifying, this demonstration should show you that there's nothing too magic going on. When `rake db:migrate` is called, ActiveRecord figures out what un-run migrations exist, and calls the `up` method of each of them, in sequence. When `rake db:rollback` is called, it runs the `down` method of the last migration.

---

#### Informative Tanget

When we use ActiveRecord Migrations, a table called `schema_migrations` is created. Open up your database with the `psql` command and use `\d` to list all tables. This particular table keeps track of which migrations have been run by recording the timestamp of the migration. This allows many developers to create migrations that will be run on the same database (assuming that no two migrations were created at exactly the same second). After running the `rake db:migrate` command, the schema_migrations table is checked against the files in `db/migrate`. If the timestamp of the file does not exist in the `schema_migrations` table, the migration is executed, and its timestamp is added. If the timestamp already exists in the table, that migration is skipped.

It is incredibly important that past migrations are not altered after sharing them with other developers. Once the change has been pushed to Bitbucket or GitHub, consider it permanent! Luckily we can write migrations to change and alter tables.

---

What do we put into the `up` and `down` methods of our migrations? Well, generally, these are used for making changes to the database of the type we've been exploring in this unit. Let's add a column, using the migration file just created:

```ruby
def up
  add_column :songs, :genre, :text
end
```

If we were to run our migration now (don't do it yet!), the code in the `up` method would be executed.

That's fine in itself. the problem would be that if we were to migrate, then roll back, then migrate again, what would happen? The migration when first run would add the column called **genre** to the **songs** table. Then, when we rolled back, the message would display, but the schema would be unchanged; and then when we migrated again, ActiveRecord would be asked to create a column that already exists.

**To use migrations well, they should be as symmetrical as possible**. When a column is created in one direction, it needs to be dropped going the other direction. Modify your migration to reflect this premise.

```ruby
def up
  add_column :songs, :genre, :text
end

def down
  remove_column :songs, :genre
end
```

See what's happening here? With the changes made, migrate your database, then check the schema, in the `db/schema.rb` file. When you've confirmed that the column was added, rollback, and check again. The column should be gone. You can repeat this cycle as often as you want. _Note:_ You don't need to specify `:text` in the rollback since a column's type doesn't matter if it's being removed.

#### The `change` method

If we include a  `change` method in our migration instead of separate `up` and `down` methods, ActiveRecord will run the migration as expected when we run `rake db:migrate`. If we then want to rollback the migration by running `rake db:rollback`, it will essentially run the change method in reverse. ActiveRecord is smart, so if it sees `add_column :songs, :genre, :text` inside the `change` method, it knows to call `remove_column :songs, :genre` if you then try to rollback the migration.

This is great most of the time, but sometimes we need to use separate `up` and `down` methods. Think about what would happen if, after running the migration below, we tried to roll-back:

```ruby
class RemoveArtistFromSongs < ActiveRecord::Migration
  def change
    remove_column :songs, :artist
  end
end
```

Does ActiveRecord have enough information to recreate the `artist` column when you rollback the migration? What piece of information is missing?

---

Migrations are a sufficiently large topic. Since they can execute any arbitrary Ruby code, you could have any valid ruby code in a migration. The task is left to you to explore migrations through the [extensive online documentation](http://guides.rubyonrails.org/active_record_migrations.html).

---

### Using Migrations

We have explored the idea of using SQL and ActiveRecord, interchangeably. Using SQL effectively is an important tool, and one that is frequently useful in development, independently of ActiveRecord development.

However, you should carefully consider that the migration mechanism in ActiveRecord generates DDL that modifies structure rather than data. Because migrations expect a symmetry between `up` and `down` methods, creating or destroying structural elements can quickly create conflicts with the migrations in the app.

When a database is tied to an app, and expected to be managed by the app, you should use well-structured migrations to make structural changes.

The one exception to this is when problems arise that interfere with migrations: if an ad-hoc fix is required - for instance dropping a column that already exists when a migration expects to create it - SQL is "closer to the metal", and probably a better approach to use.

### Rules to Follow

#### Be Mindful When Modifying Migrations in a Team Setting

Take care in being courteous to your teammates and production environments as it pertains to your schema. The rules below apply when modifying migrations.

|Modification Scenario|Action|Reasoning|
|---|---|---|
|New migrations| migrate, rollback, migrate| Always ensure your new migrations can be run, undone, and subsequently run again|
|Unpushed but broken or incomplete migration| Rollback, edit, migrate, rollback, migrate|You have not exposed other team members to the migration, so you can safely modify it|
|Pushed, broken or incomplete migration| Generate a new migration and edit its contents, migrate, rollback, migrate| You have exposed other team members to the migration, so you must generate a new one to ensure the change will be made across all environments|


#### Always ensure the sequence of your migrations can be run without error

When a new developer joins the team, you want them to get up and running quickly. If there is a problem in your migrations, they will not be able to run the application locally without a large amount of effort. On occasion, completely drop your development database and ensure it can be rebuilt through your migrations.

### Why This is Important

Migrations provide us with a means to version our schema. This is especially useful when simultaneously working in small teams on the same application. Knowing how to write migrations to affect change on our schema is important so that you are not disruptive to other developers while you roll out additional features.
