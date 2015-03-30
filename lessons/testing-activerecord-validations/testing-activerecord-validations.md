In this article we'll introduce the `valid_attribute` gem to easily test model validations.

### Learning Goals

* Test model validations with `valid_attribute`

### Testing Validations

Let's say we were writing an application that contains a `User` model. We might specify that a user has a first name, last name, and e-mail:

```bash
$ rails generate model user first_name:string last_name:string email:string
```

E-mail addresses are notoriously difficult to validate, but we could add some simple validations to ensure we don't have any bogus data. For example, we might want to reject the following addresses:

```no-highlight
foo
foo.com
@
```

When we think about test driven development and boundary conditions, it's useful to write automated tests that will help guard against this bad data entry. We could write a unit test for each example above to ensure that they are marked as invalid:

```ruby
describe User do
  it "rejects invalid emails" do
    user = User.new
    user.first_name = "Bob"
    user.last_name = "Loblaw"
    user.email = "foo"

    expect(user.valid?).to eq(false)
  end
end
```

If we repeated this test for each of the emails we presented above, we'd end up with a lot of setup code to test very similar behavior. Thankfully, a gem exists that can help us to test both positive and negative cases for validations.

We can add `valid_attribute` to the test group of our `Gemfile` to include special matchers that will automate this process:

```ruby
group :development, :test do
  gem "rspec-rails"
  gem "valid_attribute"
end
```

Now we can refactor our test suite to simplify testing our validations:

```ruby
describe User do
  it { should have_valid(:email).when("user@example.com") }
  it { should_not have_valid(:email).when("foo", "foo.com", "@") }
end
```

With the help of `valid_attribute`, we can use actual data to test whether our validations support the data we want and invalidate improper data. We can also test for the presence of `first_name` and `last_name` attributes.

```ruby
describe User do
  it { should have_valid(:first_name).when("John", "Sally") }
  it { should_not have_valid(:first_name).when(nil, "") }

  it { should have_valid(:last_name).when("Smith", "O'Leary") }
  it { should_not have_valid(:last_name).when(nil, "") }
end
```

### Resources

* [valid_attribute](https://github.com/bcardarella/valid_attribute) on GitHub
