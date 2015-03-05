### Writing Automated Tests for the User

In this assignment we'll discuss acceptance testing and how we write tests in the context of a web application. We'll be using [Capybara][capybara_readme] with [RSpec][rspec], a popular testing framework for Ruby, as a way to write **acceptance tests**. From the [Capybara README][capybara_readme]:

> "Capybara helps you test web applications by simulating how a real user would interact with your app."

Capybara allows us to test the external behavior of your application. Using Capybara, we can write a test that closely mimics what a user would do in a given user story. We'll use this tool to ensure user story acceptance criteria are met in our application.

**Note**: You may also hear this style of test referred to as an **integration test**. They're all talking about the same thing. Some folks refer to these tests as integration tests because they involve all areas of our application.

While we have previously written unit tests to ensure our code is working the way we expect, we write acceptance tests to ensure the application **functions** the way a user would expect.

### Learning Goals

* Install Capybara and RSpec in a Sinatra application
* Use Capybara to test user behavior in an application

### Getting Started With Capybara

For this mission, we will walkthrough creating acceptance tests for an existing web application. We'll use the [calculator sinatra application][calculator-github] as a means to explore how you can write acceptance tests for your own features.


```no-highlight
cd ~/Dropbox/launchacademy
git clone https://github.com/LaunchAcademy/sinatra_calculator.git
cd sinatra_calculator
bundle
```

Here, we see a new command. The `bundle` command is used for ruby libraries that contain a `Gemfile`. You can use a `Gemfile` to specify the dependencies of your application. The `bundle` command will install the dependencies specified in the `Gemfile`.

Because we will be using rspec and capybara gems, we will need to add them to your `Gemfile`. In our calculator app, we've supplied a `Gemfile` that has a group of dependencies labeled `:development, :test`. We use this group to indicate that we only need these dependencies when we are developing our app and for when we are running automated tests. Add `rspec` and `capybara` to your Gemfile.

```ruby
group :development, :test do
  gem 'pry'
  gem 'rspec'
  gem 'capybara'
end
```

Whenever you make a change to your `Gemfile`, you should always issue the command `bundle`. Doing so will ensure that you always have the necessary dependencies installed to run your application.

We'll set up RSpec the same way we have in practicing unit testing. Create your `spec` directory and create a `spec/spec_helper.rb` file.

```no-highlight
mkdir spec
touch spec/spec_helper.rb
```

Open the `spec/spec_helper.rb` file in your favorite editor, and populate it with the following contents:

```ruby
require 'pry'
require 'rspec'
require 'capybara/rspec'

require_relative '../app.rb'

set :environment, :test

Capybara.app = Sinatra::Application
```

Here, we're requiring all of our third party libraries as well our sinatra application so that we can test it. On the last line, we're telling Capybara the application we want to test.

We'll make use of this special file in all of our acceptance tests. We will store these tests in the `spec/features` directory. 


### Acceptance Testing With Capybara

Capybara allows us to think in terms of **features** of our application. We'll have an acceptance test for each feature or user story, more or less. Let's write an acceptance test that validates the acceptance criteria below.

Remember that we want acceptance tests to mimic user behavior so that we can ensure the application is delivering the functionality that a user expects. For this calculator app, we would expect it to add two numbers when they are supplied in the form and when the user presses the `+` submit button. We could represent this functionality with the following user story and acceptance criteria.

```no-highlight
  As a calculator user
  I want to add two numbers together
  So that I can can determine the resulting sum

  Acceptance Criteria:
  
  * I must supply two numbers. If I don't, I receive an error after requesting the sum to be calculated
  * When I supply two numbers and request the sum to be calculated, I receive the mathematically correct result
````

Let's write our first automated test that asserts that the acceptance criteria is met in our application. Create a new file named `spec/features/user_adds_numbers_spec.rb`, and place the user story in the test file as shown below:

```ruby
require 'spec_helper'
feature "User adds two numbers" do
  # As a calculator user
  # I want to add two numbers together
  # So that I can can determine the resulting sum

  # Acceptance Criteria:
  
  # * When I supply two numbers and request the sum to be calculated, I receive the mathematically correct result
  # * I must supply two numbers. If I don't, I receive an error after requesting the sum to be calculated
end
```

The objective of our acceptance test is to ensure that all of the acceptance criteria is met **programatically**. In this way, we can write our tests to validate that our application meets the requirements. Let's build our first scenario to satisfy the first piece of acceptance criteria.

```ruby
require 'spec_helper'
feature "User adds two numbers" do
  # As a calculator user
  # I want to add two numbers together
  # So that I can can determine the resulting sum

  # Acceptance Criteria:

  # * When I supply two numbers and request the sum to be calculated, I receive the mathematically correct result
  # * I must supply two numbers. If I don't, I receive an error after requesting the sum to be calculated

  scenario 'supply two numbers and calculate the sum' do
    visit '/'
    fill_in 'First Number', with: '3'
    fill_in 'Second Number', with: '5'
    click_button '+'

    expect(page).to have_content("result: #{3+5}")
  end
end
```

The `scenario` block indicates a routine that we want to run as an automated test. Each scenario should make assertions about the functionality of our application. Here, we're using capybara methods to mimic what we would typically do in a web browser. We programmatically visit the index, fill in the form, and click the `+` button to submit it. We then set an expectation that the sum will be outputted on the page.

You can run this test by invoking the following command in your terminal:

```ruby
rspec spec/features/user_adds_numbers_spec.rb
```

Because we've already implemented the feature in the application provided, this test will pass. 

Notice that the second piece of acceptance criteria is a **boundary** condition. Here, we're anticipating that the user does something we wouldn't necessarily expect. Let's write a scenario that ensures that acceptance criteria is met:

```ruby
require 'spec_helper'
feature "User adds two numbers" do
  # As a calculator user
  # I want to add two numbers together
  # So that I can can determine the resulting sum

  # Acceptance Criteria:

  # * When I supply two numbers and request the sum to be calculated, I receive the mathematically correct result
  # * I must supply two numbers. If I don't, I receive an error after requesting the sum to be calculated

  scenario 'supply two numbers and calculate the sum' do
    visit '/'
    fill_in 'First Number', with: '3'
    fill_in 'Second Number', with: '5'
    click_button '+'

    expect(page).to have_content("result: #{3+5}")
  end

  scenario 'do not supply a first number' do
    visit '/'
    fill_in 'Second Number', with: '5'
    click_button '+'

    expect(page).to have_content("Error! " +
      "Please supply more than one number")
  end

end
```

Acceptance criteria and acceptance tests should in some ways expect the unexpected! Users can do crazy things, and it's a good idea to consider how they might be able to break your application. In this case, when we run the spec file again using the `rspec spec/features/user_adds_numbers_spec.rb` command we get a failing test. The application, as we've supplied it, does not currently handle for the boundary condition considered in the acceptance criteria. Equipped with a failing test, we can modify our application to get our feature working the way we expect.

We can modify our post route in `app.rb` to check for the presence of both values before attempting to calculate a result like we've demonstrated below.

```ruby
post '/calculate' do
  result = nil
  error = nil
  if params[:first_number] != '' && params[:second_number] != ''
    first_number = params[:first_number].to_i
    second_number = params[:second_number].to_i
    case params[:operation]
    when "+"
      result = first_number + second_number
    when "-"
      result = first_number - second_number
    when "*"
      result = first_number * second_number
    when "/"
      result = first_number / second_number
    else
      result = nil
    end
  else
    error = "Please supply more than one number"
  end
  erb :index, locals: { result: result, error: error }
end
```

To display the error, we'll also have to modify our `views/index.erb` file to account for it. It should look like what we've supplied below.

```erb
<h1>Calculator</h1>

<% if locals[:error] %>
  <h3>Error! <%= locals[:error] %></h3>
<% end %>

<% if locals[:result] %>
  <h3>Last result: <%= locals[:result] %></h3>
<% end %>

<form action="/calculate" method="post">
  <label for="first_number">First Number</label>
  <input type="text" name="first_number" id="first_number" />
  <br />
  <label for="second_number">Second Number</label>
  <input type="text" name="second_number" id="second_number" />
  <br />
  <br />
  <input type="submit" name="operation" value="+" />
  <input type="submit" name="operation" value="-" />
  <input type="submit" name="operation" value="*" />
  <input type="submit" name="operation" value="/" />
</form>
```

Notice how we informed our implementation based on what we expected in our tests. This, in essence, is a great demonstration of the process of **T**est **D**riven **D**evelopment where we write a failing test as a means to guide our implementation. In such a way, we can use acceptance tests to map out how we want our users to interact with our application before we've even written the feature! This helps us to get in the user's mindset, and to design an experience that works in their best interest. If we write the code first, and then write the test, we may make something more complicated or confusing than what it has to be. Writing our acceptance test first helps us to decompose the problem from a user centric perspective.

#### Safety Net

Not only do we have the functionality working described by our user stories, we now have executable code that verifies this functionality works. And, we can run this code over and over again with very little effort to ensure our app is consistently working as expected.

Having a test suite like this provides a safety net for when we make changes in the future. As long as the test suite is green we can feel confident that our new changes have not disrupted past functionality. Our test suites might not cover every edge case or test every possible combination of input, but they provide a sanity check that the main use cases still function as intended.

#### A Great Communication Tool

Acceptance tests are also great ways to communicate how a user story is realized in an application. As a new developer coming into an existing application, I can walk through each of the files in `spec/features` to gain great perspective around how the application works. Writing acceptance tests also provides other developers with stronger confidence that you've introduced a working feature to an already functional application.

#### RSpec and Capybara are both just ruby libraries

It's important to note that RSpec and Capybara are just ruby libraries. In fact, you can view their respective sources ([rspec][rspec] and [capybara][capybara]) on GitHub. `feature`, `scenario`, `visit`, `fill_in` and `page` are all ruby methods supplied to us from the capybara library. For this reason, we can also insert `binding.pry` in our scenarios to verify assumptions and check the state of the test. Try this now by putting a `binding.pry` in one of the supplied scenarios. Note how you can call all of the capybara supplied methods like `visit` and `page`.

#### A Note About Capybara and JavaScript

Recall that capybara is "mimicking" the use of a web browser. While the library is very powerful, it does not support JavaScript. That means when you run your acceptance tests, any JavaScript that appears on the page will never be evaluated. Keep this in mind when writing your acceptance tests. While some libraries exist that can help us with this problem, focus on writing acceptance tests that are oriented around server side behaviors.

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
[capybara]: https://github.com/jnicklas/capybara
[calculator-github]:https://github.com/LaunchAcademy/sinatra_calculator
[capybara_image]: http://i.imgur.com/7ZsSf.jpg
