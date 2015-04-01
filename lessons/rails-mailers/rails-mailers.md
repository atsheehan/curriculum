In this article we'll discuss how we can send emails from our Rails application using **Action Mailer**.

### Learning Goals

* Send an email in response to an event
* Build an email from a template
* Write a test to verify an email is being sent
* Configure an email provider

### Sending Notifications

Email is a popular way to notify users that something of interest has happened on our website. When a user registers to use our application we typically require an email to associate with their account so that we have some way to contact them if needed.

For this article we'll assume we have a web application that lets users list products for sale and other users can leave reviews for them. Let's see how we can send an email in response to a new review on a product. First we'll consider the controller for saving a new review on a product:

```ruby
class ReviewsController < ApplicationController
  before_action :authenticate_user!

  def new
    @product = Product.find(params[:product_id])
    @review = Review.new
  end

  def create
    @product = Product.find(params[:product_id])
    @review = @product.reviews.build(review_params)
    @review.user = current_user

    if @review.save
      redirect product_path(@product)
    else
      render :new
    end
  end

  private

  def review_params
    params.require(:review).permit(:body)
  end
end
```

This is a pretty standard controller for saving new reviews for a product. What we would like to do is to notify the owner of the product that someone has left a review by sending them an email. We can update our `create` action to send off that email whenever a review is successfully saved:

```ruby
if @review.save
  # Send an email here...
  redirect product_path(@product)
else
  render :new
end
```

To actually send an email we can define a new **Mailer** in our Rails application for sending review notifications. Since we're sending emails to notify product owners of a new review, we'll use a `ReviewNotifier` mailer:

```ruby
if @review.save
  ReviewNotifier.new_review(@review).deliver_later
  redirect product_path(@product)
else
  render :new
end
```

We'll have to define the `ReviewNotifier` class in `app/mailers/review_notifier.rb`:

```ruby
class ReviewNotifier < ApplicationMailer
  def new_review(review)
    # Build the email in here...
  end
end
```

The `new_review` method will return a mail object that we can call `deliver_later` on. By default, Rails will attempt to deliver the mail instantly (even if calling `deliver_later`) but we can configure Rails to use a background queue later to send asynchronously.

One other interesting thing about this class is that we define `new_review` as an instance method but we call it as a class method (i.e. `ReviewNotifier.new_review(@review).deliver_later`). The `ApplicationMailer` base class automatically catches these class method calls and will handle instantiating the mailer class and calling the appropriate method for us.

### Email Templates

We have our mailer setup but what does our email look like? What information do we need to include in the mail?

Mailers in Rails tend to behave similarly to controllers. When we call a controller action, it usually retrieves some information and feeds it into a view that transforms it into an HTML page (or whatever format is being requested). A mailer does the same thing: given some information (in this example, a review for a product) we want to generate an email to send to the product owner.

Let's consider what we want our email to look like for a new product review:

```no-highlight
FROM: reviews@example.com
SUBJECT: New Review for Kitten Mittens
BODY:

Hello Charlie,

Dee Reynolds has left a new review for your product Kitten Mittens.

Peace!
```

Rather than generating this email within the `new_review` method, we can define an ERB view in `app/views/review_notifier/new_review.text.erb` and pass information in via instance variables:

```erb
Hello <%= @review.product.user.first_name %>,

<%= @review.user.full_name %> has left a new review for your product <%= @review.product.name %>.

Peace!
```

Now we just need to update our `ReviewNotifier` mailer to define the `@review` instance variable as well as set the email subject and sender fields:

```ruby
class ReviewNotifier < ApplicationMailer
  default from: "reviews@example.com"

  def new_review(review)
    @review = review

    mail(
      to: review.product.user.email,
      subject: "New Review for #{review.product.name}")
  end
end
```

The `mail` method is similar to `render` for controllers and is where we can specify the recipient as well as the subject of the mail. It will use the template in `app/views/review_notifier/new_review.text.erb` by default and have access to any instance variables we've defined (`@review` in this case).

### Testing Email Deliveries

When we're writing tests for our application we'll frequently encounter scenarios where we need to send an email. Since our test suites should be run often regularly and are capable of running hundreds of tests in a matter of seconds, we want to avoid spamming our inboxes. We want to test that an email **will** be sent in response to some event but it doesn't actually need to be delivered in the test environment. We just want to check that it ends up in the delivery queue.

Let's consider the following test:

```ruby
scenario "review a product" do
  product = FactoryGirl.create(:product)
  user = FactoryGirl.create(:user)

  sign_in_as(user)

  visit new_product_review_path(product)

  fill_in "Review", with: "Total garbage."
  click_button "Submit Review"

  expect(page).to have_content("Total garbage.")
  expect(ActionMailer::Base.deliveries.count).to eq(1)
end
```

Here we have a user who signs in and leaves a kindly-worded review for a product. After the review has been submitted, we check that the review content is displayed on the page and that we've successfully queued up an email to send.

The `ActionMailer::Base.deliveries` queue will contain the mails to be sent but won't actually send them in the test environment. We can then check to see how many emails are in there to ensure our application is sending mail at the appropriate time. One caveat is that Rails won't clear this queue between tests so we have to handle this explicitly at the start of the test:

```ruby
scenario "review a product" do
  # Clear out any previously delivered emails
  ActionMailer::Base.deliveries.clear

  product = FactoryGirl.create(:product)
  user = FactoryGirl.create(:user)

  sign_in_as(user)

  visit new_product_review_path(product)

  fill_in "Review", with: "Total garbage."
  click_button "Submit Review"

  expect(page).to have_content("Total garbage.")
  expect(ActionMailer::Base.deliveries.count).to eq(1)
end
```

The call to `ActionMailer::Base.deliveries.clear` at the beginning ensures that if we find any emails in the queue, it happened during this test. We could add it to the start of every test but that would get tedious after a while. An alternative is to update our `spec/spec_helper.rb` file to clear out the deliveries queue before every test:

```ruby
RSpec.configure do |config|
  # ...

  config.before :each do
    ActionMailer::Base.deliveries.clear
  end

  # ...
end
```

The `config.before :each` block will run this snippet of code before every test to ensure that our email queue starts empty.

### Configuring an Email Server

To send an email we need to configure an email server. Rather than setting up our own server we can rely on a third-party to handle the details for us. We'll demonstrate how we can configure the [Mandrill service](https://addons.heroku.com/mandrill) to handle sending emails for us.

To get started, first setup the Mandrill addon to an existing Heroku application:

```no-highlight
$ heroku addons:add mandrill:starter
```

This will add a few environment variables to the Heroku configuration. Now we just need to update our `config/environment/production.rb` to utilize those environment variables when it is deployed:

```ruby
config.action_mailer.delivery_method = :smtp
config.action_mailer.smtp_settings = {
  port: "587",
  address: "smtp.mandrillapp.com",
  user_name: ENV["MANDRILL_USERNAME"],
  password: ENV["MANDRILL_APIKEY"],
  domain: "heroku.com",
  authentication: :plain
}
```

Now when we run `ReviewNotifier.new_review(@review).deliver_later` in our application, it will route the message through Mandrill's email server.
