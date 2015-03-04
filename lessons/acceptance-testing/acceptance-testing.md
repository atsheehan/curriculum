### Writing Automated Tests for the User

In this assignment we'll discuss acceptance testing and how we write tests in the context of a Rails application. We'll be using [Capybara][capybara_readme] with [RSpec][rspec], a popular testing framework for Ruby, as a way to write **acceptance tests**. From the [Capybara README][capybara_readme]:

> "Capybara helps you test web applications by simulating how a real user would interact with your app."

Capybara allows us to test the external behavior of your application. Using Capybara, we can write a test that closely mimics what a user would do in a given user story. We'll use this tool to ensure user story acceptance criteria are met in our application.

**Note**: You may also hear this style of test referred to as an **integration test**. They're all talking about the same thing. Some folks refer to these tests as integration tests because they involve all areas of our application.

### Acceptance Testing With Capybara

Capybara allows us to think in terms of **features** of our application. We'll have an acceptance test for each feature or user story, more or less. Let's write an acceptance test that validates the acceptance criteria below.

```no-highlight
As a user
I want to see all the events on one page
So that I know what events are happening

Acceptance Criteria:

* I see a title that lets me know I'm on the right page
* I see all of the events listed
```

Our acceptance tests will be written in Ruby and are stored in the `spec/features` directory. It's important that we use this directory as RSpec will infer which type of test it is based on the directory name.

Start by creating a new file to hold our test at `spec/features/user_views_events_listing_spec.rb`:

```no-highlight
$ mkdir spec/features
$ touch spec/features/user_views_events_listing_spec.rb
```

An acceptance test for the first piece of acceptance criteria might look something like this:

```ruby
require 'spec_helper'

feature "User visits the events page" do
  # As a User
  # I want to see all the events on one page
  # So that I know what events are happening
  #
  # Acceptance Criteria:
  #
  # * I see a title that lets me know I'm on the right page
  # * I see all of the events listed

  it "displays a title" do
    visit '/events'
    expect(page).to have_content "All The Events"
  end
end
```

Let's take a closer look at the test. The functionality that we're testing is that the user sees a title when they visit the page so we create a new acceptance test and give it a descriptive name:

```ruby
it "displays a title" do
  # test goes in here...
end
```

RSpec recognizes the `it` method as the definition of a new test. What we want to do with our test is to simulate a user's behavior on the site and assert that the site is behaving as we intend it to. In this case we want to check that a user visiting a certain page on our site will see a title that lets them know they're on the events page:

```ruby
it "displays a title" do
  visit '/events'
  expect(page).to have_content "All The Events"
end
```

The `visit` method will simulate a user entering a URL in your web browser and visiting the page. It is issuing an HTTP request and a test version of the server is serving your acceptance test with a response. The next step is to look at what the response contained. The response is made available in a `page` method that we can use to assert certain properties of the response. Here we're checking that the page content contains the title *All The Events* whenever a user visits the path `/events`.

You run these acceptance tests we can use the `rake spec` command. Your test should fail. This is because the page you're accessing does not have the text "All the Events". To get this acceptance test to pass, edit the **view** file that controls the HTML that is output on the events **index** page, `app/views/events/index.html.erb`, so that it has the correct title that our test is expecting:

```HTML
<h1>All The Events</h1>

<table>
  <thead>
```

After modifying the markup to match the expectation, rerun your tests to ensure your spec is now green.

#### Using Data in our Test

The next part of our User Story's acceptance criteria says "I see all of the events listed". Let's work on getting a test set up that verifies that we can indeed see all of the events on the page. Add another `it` block to your feature spec:

```ruby
it "sees all the events listed on the page" do
  # Create two events so we can test that they're displayed on the page
  event1 = Event.create!(location: "My Backyard")
  event2 = Event.create!(location: "Chuckie Cheese")

  visit '/events'

  expect(page).to have_content event1.location
  expect(page).to have_content event2.location
end
```

Whenever we run our test suite, every single test is run in isolation. That means it starts with an empty database regardless of what previous tests have done. If our tests rely on data being available to assert certain functionality, we have to provide that data at the start of the test.

Here we're asserting that the `/events` path should contain the location of each event, but to do so we need to first create a few events so that there is something to display. We can create two `Event` records at the start of our test:

```ruby
event1 = Event.create!(location: "My Backyard")
event2 = Event.create!(location: "Chuckie Cheese")
```

Now when the user visits `/events` we should expect that those two events will be displayed on the page which we assert with the following code:

```ruby
visit '/events'

expect(page).to have_content event1.location
expect(page).to have_content event2.location
```

Try running the new test with `rake spec`. The test should already be passing since our app already includes this functionality, but now we have a test to verify that this functionality works every single time we run our test suite. If someone makes changes at some point in the future that breaks this feature, our test will fail and we can catch the error quickly without having to manually test this behavior every time.

#### Filling in Forms

A new user story just came in from the product owner:

```no-highlight
As a User
I want to create a new Event
So that other users can find the Event

Acceptance Criteria:

* I must provide a location
```

In order to do this, we're going to need to fill out a form on the new event page. Capybara gives us a nice [DSL (Domain Specific Language) for filling out forms on a page](https://github.com/jnicklas/capybara#interacting-with-forms).

Create a new file `spec/features/user_creates_an_event_spec.rb` that contains the following:

```ruby
require 'spec_helper'

feature "User creates a new Event" do
  # As a User
  # I want to create a new Event
  # So that other users can find the Event
  #
  # Acceptance Criteria:
  #
  # * I must provide a location

  it "creates a valid event" do
    # Visit the page containing the new event form
    visit '/events/new'

    # Fill in the input field with the 'Location' label
    fill_in "Location", with: "Launch Academy"
    click_on "Create Event"

    expect(page).to have_content "Event was successfully created"
    expect(Event.count).to eq(1)
  end
end
```

Now we've written a test that verifies that we can create a new `Event` by filling out the form and submitting it. The `fill_in` method can be used to simulate a user typing in a text field. In this case we're having the user type in *Launch Academy* in a text field that has the label *Location*. Once this is done we use the `click_on` method to simulate the user clicking on a button or link named *Create Event*. We then check that an `Event` record was actually created and that the user is notified with a success message.

This test checks that a user can create an event but does it meet the acceptance criteria? We want to make sure that we cannot create a new `Event` without providing a value for location. To do this we can add another test that asserts that we see an error when we submit a form for a new `Event` without providing a location.

```ruby
it "requires a location" do
  visit '/events/new'

  # Notice that we have omitted the step where we fill out the location field
  click_on "Create Event"

  expect(page).to have_content "Location can't be blank"
  expect(Event.count).to eq(0)
end
```

Run the tests and we should see that this last test fails. Try adding a [validation](http://guides.rubyonrails.org/active_record_validations.html) to make sure that a value is present for the location attribute on the `Event` model in `app/models/event.rb`:

```ruby
class Event < ActiveRecord::Base
  validates :location, presence: true
end
```

Re-run the tests and everything should be green.

#### Safety Net

Not only do we have the functionality working described by our user stories, we now have executable code that verifies this functionality works. And we can run this code over and over again with very little effort to ensure our app is consistently working as expected.

Having a test suite like this provides a safety net for when we make changes in the future. As long as the test suite is green we can feel confident that our new changes have not disrupted past functionality. Our test suites might not cover every edge case or test every possible combination of input but they provide a sanity check that the main use cases still function as intended.

### Resources

* [Capybara](https://github.com/jnicklas/capybara)
* [Request Specs and Capybara](http://railscasts.com/episodes/257-request-specs-and-capybara)
* [Acceptance Testing with RSpec and Capybara](http://www.youtube.com/watch?v=MhApcLK82KE)
* [All the things you can do with Capybara](https://github.com/jnicklas/capybara#the-dsl)

### Rules to Follow

#### Use Capybara for acceptance testing

Capybara gives us the ability to interact with our web application in a repeatable and scripted way. As a developer, a good way to think about writing Capybara tests is like writing a script for a play. A play's script tells the actors where to be on the stage, what lines to say, and what emotions to feel.

Capybara gives our tests a script to follow. We can navigate to pages, fill in forms, click on buttons and/or links, and make assertions about the state of the database and application proceeding the manipulation of data.

### Why This is Important

#### Acceptance testing ensures business requirements are met

As software developers, it is important that we make sure that we are meeting the requirements of our stakeholders and creating business value. We use acceptance testing to make sure that our user stories and acceptance criteria have been fulfilled.

[capybara_readme]: https://github.com/jnicklas/capybara/blob/master/README.md
[rspec]: https://github.com/rspec/rspec
[capybara_image]: http://i.imgur.com/7ZsSf.jpg
[events_index]: http://localhost:3000/events
