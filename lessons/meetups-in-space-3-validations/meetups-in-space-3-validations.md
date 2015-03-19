### Learning Objectives

* Use ActiveRecord validations at both the database and model level

### Instructions

* For each column in your database, decide what (if any) validations it should have for incoming data. Use [change_column](http://edgeguides.rubyonrails.org/active_record_migrations.html#changing-columns) to add database-level validations to each necessary column. `change_column` uses the following syntax:
  
  ```
  change_column table_name, column_name, column_type, constraints
  ```
  
  - For example, if I am adding a `null: false` constraint to my `name` column in a `songs` table, my migration might look like this:

  ```ruby
  class AddNullFalseToSongsName < ActiveRecord::Migration
    def up
      change_column :songs, :name, :text, null: false
    end
    def down
      change_column :songs, :name, :text
    end
  end
  ```
  
  - Note how `up` and `down` are used here for `change_column` rather than `change` - this is because `change_column` is something that cannot be rolled back automatically, meaning that it's up to us to explicitly state what should happen during a rollback.
* For each constraint you created in your database, create a corresponding validation in your model for that table.
* When you're done with both these steps, finish the [user stories](meetups-in-space-1) provided in the original assignment. If you have time, attempt some of the [optional user stories](meetups-in-space-2)! 
