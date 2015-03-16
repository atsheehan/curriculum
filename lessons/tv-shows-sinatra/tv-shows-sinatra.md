**Acceptance tests** are high-level tests that essentially walk through an application as though they were a user. Our acceptance tests will read like a script of a user interacting with our application, ensuring that acceptance criteria is met along the way. We might have a test that walks through a user signing up for our app, adding a record to the database, or viewing a particular item's page.

In this challenge you'll retroactively add acceptance tests to a working application to provide better test coverage and possibly uncover subtle bugs.

### Learning Goals

* Use capybara to simulate a user interacting with a web page.

### Setup

This challenge includes an existing Sinatra application that catalogues information on television shows and allows users to add new shows to the list. The application utilizes ActiveRecord for handling interactions with the database and comes with the **TelevisionShow** model pre-defined.

To get started, run the following commands to install any dependencies and setup the database:

```no-highlight
$ bundle
$ rake db:create
$ rake db:migrate
```

The `db:create` and `db:migrate` commands will create a blank database and run some SQL commands to add the necessary tables, respectively. The details are not important as the migrations are already defined but you can view the database schema from the **db/schema.rb** file.

Other files and folders of interest include:

* **app/models/television_show.rb**: Defines a model to represent a single television show stored in the **television_shows** table. Includes validations to ensure that new television shows being added include the appropriate fields.

* **app/views**: Includes the HTML templates for the application.

* **config/database.yml**: Defines the connection information for the database. ActiveRecord will use this file by default if it exists. Within the file there are two environments: **development** and **test**. The `rake db:create` command will create two databases that contain the same schema definition. The _development_ environment is used when running the server locally, but for automated test suites we'll use the _test_ environment so that we can clear out the database between each test run without affecting development.

At this point try starting the server and manually test out the existing functionality:

```no-highlight
$ ruby server.rb
[2015-03-16 00:04:53] INFO  WEBrick 1.3.1
[2015-03-16 00:04:53] INFO  ruby 2.1.5 (2014-11-13) [x86_64-linux]
== Sinatra/1.4.5 has taken the stage on 4567 for development with backup from WEBrick
[2015-03-16 00:04:53] INFO  WEBrick::HTTPServer#start: pid=14464 port=4567
```

### Instructions

The purpose of this challenge is to add more acceptance tests to **spec/features** to improve test coverage and ensure existing functionality is working as expected. There is a single acceptance test already defined in **spec/features/view_tv_shows_spec.rb** for viewing a list of TV shows on the index page. Run the test suite using the following command:

```no-highlight
$ rake spec
```

This will run all files ending in `_spec.rb` within the `spec` directory. You should see output similar to:

```no-highlight
.****

Pending: (Failures listed here are expected and do not affect your suite's status)

  1) user adds a new TV show successfully add a new show
     # Not yet implemented
     # ./spec/features/add_tv_show_spec.rb:19

  2) user adds a new TV show fail to add a show with invalid information
     # Not yet implemented
     # ./spec/features/add_tv_show_spec.rb:20

  3) user views list of TV shows view details for a TV show
     # Not yet implemented
     # ./spec/features/view_tv_shows_spec.rb:42

  4) user views list of TV shows view details for a TV show with missing information
     # Not yet implemented
     # ./spec/features/view_tv_shows_spec.rb:43


Finished in 0.09108 seconds (files took 0.54357 seconds to load)
5 examples, 0 failures, 4 pending
```

There are two files in `spec/features` that contain **pending** acceptance tests. A pending acceptance test is a test without an implementation that serves as a placeholder. To implement a pending test suite, replace `pending` with `scenario` and add the test body:

```ruby
pending "successfully add a new show"

# becomes

scenario "successfully add a new show" do
  # YOUR CODE GOES HERE
end
```

There are four pending acceptance tests in total that need to be defined. The user stories and acceptance criteria are defined inline in the spec file. Once you are finished with the acceptance tests and they are passing you should receive the following output:

```no-highlight
$ rake spec

.....

Finished in 0.10347 seconds (files took 0.54015 seconds to load)
5 examples, 0 failures
```

Note that even though the app is complete, that **does not** guarantee that the functionality is correct. If your acceptance tests are failing for whatever reason, verify that the app is behaving as intended and apply the necessary changes if it is not.

### Tips

ActiveRecord provides **validations** to ensure that user-supplied information meets our acceptance criteria before saving it to the database. These validations are checked when trying to `save` a model to the database. This method will return return **true** or **false** depending on whether the validations passed or not. If the validations failed, the `errors` method returns information about each of the validations that did not pass:

```ruby
show = TelevisionShow.new({
  title: "The Simpsons", genre: "Animation",
  starting_year: 1989, ending_year: 0
})

show.save
# => false

show.errors.full_messages
# => [
#   "Genre is not included in the list",
#   "Ending year must be greater than 1900"
# ]
```

You can use this information to inform the user as to why their television show was not saved appropriately.

### Extra Challenge: Test-Drive a New Feature

In this challenge we added the tests retroactively to an existing application. If we practice **test-driven development** we often write our tests **before** attempting to implement the functionality.

Try writing an acceptance test for the ability to edit an existing TV show:

```no-highlight
As a TV fanatic
I want to edit an existing show
So that I can correct any foolish mistakes

Acceptance Criteria:
* Editing a show provides a pre-populated form for each field.
* Submitting the edit form will update a show if all validations pass.
* The user is redirected to the details page for that show if successfully updated.
* If the update fails any validations, re-display the form with the appropriate error messages.
```

Once you have a failing acceptance test for this user story, update the application to allow for users to edit an existing show. For this assignment do not worry about user authentication or privileges: assume all users can edit any show.
