In this article we'll introduce the `shoulda` gem to simplify testing model associations.

### Learning Goals

* Test associations with `shoulda`

### Testing Associations

Let's test drive the creation of a model layer for a basic TODO list. A TODO list contains a series of tasks so we'll need a Task model. We would first consider what attributes we need to include as part of our task object. At a minimum, we would want a title, an optional description, and a user that created the task.

```bash
$ rails generate model task title:string description:text user_id:integer
```

Before we start fleshing out the model and run the migrations, we can add unit tests for our [model validations](/lessons/testing-activerecord-validations):

```ruby
describe Task do
  it { should have_valid(:title).when("a title") }
  it { should_not have_valid(:title).when(nil, "") }

  it { should have_valid(:user).when(User.new) }
  it { should_not have_valid(:user).when(nil) }
end
```

The introduction of these tests will inform our schema design. Recall that we want our schema constraints to match our validations where possible. These tests indicate that we want constraints on our title and user_id fields. With our tests written, we can now modify our migration to reflect these constraints.

```ruby
class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :title, null: false
      t.text :description
      t.integer :user_id, null: false

      t.timestamps
    end
  end
end
```

We can now run our migrations to create the table in our database:

```no-highlight
$ rake db:migrate && rake db:rollback && rake db:migrate
```

If we run our test suite using `rake spec` we get expected results. The test suite is red because we have not yet introduced validations to our models that would make our tests pass:

```ruby
class Task < ActiveRecord::Base
  validates :title, presence: true
  validates :user, presence: true
end
```

At this point we run into an issue. We have defined a `user_id` foreign key, but we have yet to define the association that uses it. Before adding the `belongs_to :user` method we should also define another unit test to properly test-drive the association between tasks and users.

### Shoulda

The [`shoulda` gem](https://github.com/thoughtbot/shoulda) provides several matchers to simplify testing associations. We first include it in our Rails application by adding it to the Gemfile:

```ruby
group :development, :test do
  gem "rspec-rails"
  gem "shoulda"
  gem "valid_attribute"
end
```

Now, we can make use of the matchers in `shoulda` to quickly validate an association has been properly set up. We can add the following to our RSpec file `spec/models/task_spec.rb`:

```ruby
describe Task do
  it { should belong_to :user }

  it { should have_valid(:title).when("a title") }
  it { should_not have_valid(:title).when(nil, "") }

  it { should have_valid(:user).when(User.new) }
  it { should_not have_valid(:user).when(nil) }
end
```

Informed by our failing tests, we can now safely create a relationship between users and their tasks. In order to do so, we must first create our `User` model.

```ruby
$ rails generate model user first_name:string last_name:string
```

Again, we will use tests to inform the implementation of our `User` object. This will result in lots of failing tests. Not to worry! We will clean them up as we build out our implementation.

```ruby
describe User do
  it { should have_valid(:first_name).when("Johnny") }
  it { should_not have_valid(:first_name).when(nil, "") }

  it { should have_valid(:last_name).when("Smith") }
  it { should_not have_valid(:last_name).when(nil, "") }
end
```

We could watch these specs fail in addition to the Task failures we introduced previously, because we have not yet migrated or introduced these validations. Here again, though, our validation tests inform our schema constraints. We can now safely modify our migration to reflect these requirements.

```ruby
class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false

      t.timestamps
    end
  end
end
```

We can now run our migrations and run our spec suite.

```no-highlight
$ rake db:migrate && rake db:rollback && rake db:migrate
$ rake spec
```

We should be seeing different failures at this point. Let's modify our User model to enforce the validations dictated by our tests in `app/models/user.rb`.

```ruby
class User < ActiveRecord::Base
  validates :first_name, presence: true
  validates :last_name, presence: true
end
```

Continuing to be informed by our failing unit tests, we can now safely add a `belongs_to :user` association in our `Task` model.

```ruby
class Task < ActiveRecord::Base
  belongs_to :user

  validates :title, presence: true
  validates :user, presence: true
end
```

Once that is complete, we get a green suite when running our tests again.

We've tested that a task belongs to a user, but let's test that we can retrieve the tasks for a given user:

```ruby
describe User do
  it { should have_many :tasks }

  it { should have_valid(:first_name).when("Johnny") }
  it { should_not have_valid(:first_name).when(nil, "") }

  it { should have_valid(:last_name).when("Smith") }
  it { should_not have_valid(:last_name).when(nil, "") }
end
```

The `should have_many :tasks` test will check that the user model has the appropriate association defined. To get this to pass we can update our User model:

```ruby
class User < ActiveRecord::Base
  has_many :tasks

  validates :first_name, presence: true
  validates :last_name, presence: true
end
```

We now have a green test suite, but what happens if a user is deleted? We can use `shoulda` to add additional constraints on our associations and ensure that we have them configured correctly:

```ruby
describe User do
  it { should have_many(:tasks).dependent(:destroy) }

  # ...
end
```

This test checks that a user has many tasks and that when a user is destroyed, all of their tasks are removed as well. We can include this in our User model by defining a **destroy dependency**:

```ruby
class User < ActiveRecord::Base
  has_many :tasks, dependent: :destroy
  ...
end
```

Now we should have a clean test suite with all of our associations properly tested.
