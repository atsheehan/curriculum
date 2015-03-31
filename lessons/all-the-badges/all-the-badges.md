![All the
Badges](https://dl.dropboxusercontent.com/s/zbmv55zips0o2xo/Screen%20Shot%202013-10-15%20at%2011.13.39%20AM.png)

Have you seen all of those nifty badges that some people have on their Github
repos? They're really easy (and FREE) to set up. Each of of them is connected to
a specific service that can be used to display information about the status of
your app.

These are instructions for setting up **Travis CI**, **Coveralls**, and
**Code Climate**, and **Hound CI**. This guide assumes that you are using:

- Rails 4
- PostgreSQL
- RSpec

## Resources

- [Travis CI](https://travis-ci.org/)
- [Coveralls](https://coveralls.io/)
- [Code Climate](https://codeclimate.com/)
- [Hound CI](https://houndci.com/sign_in)

## Services

### Travis CI

[Travis CI](https://travis-ci.org/) is a hosted continuous integration service
for the open source community. Travis can be configured to do all kinds of
things. The default setup will build your application and then run all of
your tests. This process will happen every time that you issue a pull request on
GitHub. This is useful because it lets you know whether merging a pull request
into master is going to make your app better or cause a bunch of stuff to break.
It also allows you to add your first little green badge to your README!

#### Setup

##### Step 1

Go to [https://travis-ci.org/](https://travis-ci.org/) and flip the switch to
turn on it on for your GitHub repo.

##### Step 2

You can configure the way that Travis CI builds our app by creating a
`.travis.yml` in the root directory of your app.

In `.travis.yml`:

```no-highlight
language: ruby
rvm:
  - 2.0.0  # replace this with the ruby version you are using in development
before_script:
  - psql -c 'create database YOUR_APP_NAME_test;' -U postgres
```

**Hint: Don't forget to substitute your app name and your ruby version in
the code above.**

Now, whenever you issue a pull request, Travis CI will build your app, run the
tests, and then let you know whether or not the build has passed.

If you would like to learn more about how you can configure Travis, check out
the [Travis CI Documentation](http://about.travis-ci.org/docs/).

---

### Coveralls

[Coveralls](https://coveralls.io/) is for "Test Coverage History & Statistics."
It integrates easily with Travis CI by tracking which lines of your code
actually get exercised when your test suite runs. It will give you a coverage
percentage for each of your files along with one for the app overall. This is
really useful if you're trying to determine which parts of your app are not
currently covered by your tests.

#### Setup

```ruby
# Gemfile

group :test do
  gem 'coveralls', require: false
end
```

```ruby
# spec/spec_helper.rb

require 'coveralls'
Coveralls.wear!('rails')
```

The `coveralls` gem depends on the `simple_cov` gem to test your code coverage.
When your tests are run it will provide a report of your code coverage and put
it into a `/coverage` directory. We want to ignore this to reduce noise in our
git commits.

In `.gitignore`:

```
/coverage
```

### Code Climate

[Code Climate](https://codeclimate.com/) is "Automated Ruby Code Review". It's
no substitute for manual code review but it's a good way to gain some insight
into which parts of your app could use refactoring. Even better, it lets you add
another badge to your App's README to show off how awesome your app's "GPA" is.

#### Setup

Code Climate is the easiest of these services to set up and doesn't require you
to change your code at all. The only thing that you will need to edit is your
README, and that's only so you can add your awesome new badge.

It can be kind of tricky to find the right page to add your repo but [here it
is](https://codeclimate.com/github/signup). Just add your app and you're all
set.

---

#### Hound CI

> Review your Ruby code for style guide violations with a trusty hound

Add [this code](https://github.com/LaunchAcademy/launchcop/blob/master/config/rubocop.yml) to a `.hound.yml` file in the root of your project directory.

Then, sign in on [the website](https://houndci.com/) and flip the switch for the
GitHub repo that you want to add it to.

---

### Adding All the Badges

Now that all of your services are set up, you can add the awesome badges by
editing your `README.md` on Github. You can find the embed code for each of the
services on their respective websites or use the following template:

```no-highlight
[![Build Status](https://travis-ci.org/<YOUR_GITHUB_USERNAME>/<YOUR_REPO_NAME>.svg?branch=master)](https://travis-ci.org/<YOUR_GITHUB_USERNAME>/<YOUR_REPO_NAME>) [![Code Climate](https://codeclimate.com/github/<YOUR_GITHUB_USERNAME>/<YOUR_REPO_NAME>.png)](https://codeclimate.com/github/<YOUR_GITHUB_USERNAME>/<YOUR_REPO_NAME>) [![Coverage Status](https://coveralls.io/repos/<YOUR_GITHUB_USERNAME>/<YOUR_REPO_NAME>/badge.png)](https://coveralls.io/r/<YOUR_GITHUB_USERNAME>/<YOUR_REPO_NAME>)
```

**Hint: Make sure to replace all of the occurrences of
`<YOUR_GITHUB_USERNAME>/<YOUR_REPO_NAME>` with the correct information.**
