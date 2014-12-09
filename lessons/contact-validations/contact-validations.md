We've written a small Sinatra application to keep track of all of our contacts. Currently, there aren't any validations in place to help make sure that we're entering valid data. We need to fix that!

## Learning Goals

- Learn how to use built-in Active Record validation helpers
- Become exposed to RSpec/Capybara tests
- Decipher test feedback to determine which validations need to be added

## Resources

- [Active Record Validations](http://guides.rubyonrails.org/active_record_validations.html)
- [RSpec - Getting Started](https://relishapp.com/rspec/docs/gettingstarted)
- [Capybara](https://github.com/jnicklas/capybara)

## Getting Started

```no-highlight
# Clone down the repo from GitHub
git clone git@github.com:LaunchAcademy/contact_validations.git

# Move into your app's directory
cd contact_validations

# Install all the gems
bundle install

# Create the database
rake db:create

# Migrate the database
rake db:migrate

# Copy the db schema to test db
# (Note: This command is deprecated in newer versions of Rails:
#  As of Rails 4.1, your test db will be updated whenever you run
#  rake db:migrate)
rake db:test:prepare
```

## Instructions

We've already written some tests that cover the validations that we wish we had.
You can run the tests with `rspec spec`. When you run the tests, you should see
a bunch of failures that look something like this:

```no-highlight
Failures:

1) User creates a contact user submits a blank contact form
Failure/Error: expect(page).to have_content "Email can't be blank"
expected to find text "Email can't be blank" in "Contact created successfully! Contacts Add a Contact ,"
# ./spec/features/user_creates_a_contact_spec.rb:22:in `block (2 levels) in <top (required)>'
# ./spec/spec_helper.rb:21:in `block (3 levels) in <top (required)>'
# ./spec/spec_helper.rb:20:in `block (2 levels) in <top (required)>'
```

Your goal is learn how to decipher the feedback from the tests to determine
which Active Record validations to add to the `Contact` model.

This first failure is because the test expected to find text "Email can't be
blank" on the page somewhere.

The first line of the backtrace section of the test failure is:

```ruby
# ./spec/features/user_creates_a_contact_spec.rb:22:in `block (2 levels) in <top (required)>'
```

From this, we know that the test that failed is located on line 22 of
`./spec/features/user_creates_a_contact_spec.rb`. If you open up that file,
you'll see that the test on line 22 looks like:

```ruby
scenario "user submits a blank contact form" do
  visit '/contacts/new'

  click_on "Create"

  expect(page).to have_content "Email can't be blank"
  expect(page).to have_content "First name can't be blank"
  expect(page).to have_content "Last name can't be blank"
  expect(page).to have_content "Phone can't be blank"
  expect(page).to have_content "State can't be blank"
  expect(page).to have_content "There were some errors the provided information."
end
```

This test will navigate to `/contacts/new` and click on the "Create" button,
without filling in any of the input fields in the form. We're then expecting to
see a couple error messages displayed on the page.

If you open up `app/views/new.erb`, you'll see that there is already some code
set up to iterate through and display any error messages that are attached to
our model:

```html
<div class="errors">
  <ul>
    <% @contact.errors.full_messages.each do |error| %>
      <li><%= error %></li>
    <% end %>
  </ul>
</div>
```

> Read more about how this works at
> [Working with Validation Errors](http://guides.rubyonrails.org/active_record_validations.html#working-with-validation-errors)

We can make sure that the error message "Email can't be blank" is displayed by
using the [Active Record presence validation
helper](http://guides.rubyonrails.org/active_record_validations.html#presence)
in our `Contact` model:

```ruby
class Contact < ActiveRecord::Base
  validates :email, presence: true

# ...
end
```

Run that test again with `rspec spec/features/user_creates_a_contact_spec.rb:22`
and the test should now fail when it gets to line 23.

Continue following this pattern of running the tests and then adding the
appropriate validations until all of the tests are passing.

**You should not modify any of the tests themselves but feel free to open and
and read them to figure out what the test is looking for.**
