In this challenge you'll be building a web application in groups of 3-4 developers. The application should allow users to add new items and write reviews for those items, where the item can be some product or entity of your choosing (e.g. a review site for restaurants, food trucks, playlists, other review sites, etc.).

Your site will be described as a series of user stories. You'll be expected to write user stories and formulate acceptance criteria, write tests to reflect those criteria, and then write code and create Rails elements that will cause those tests to pass.

The purpose of this project is two-fold:

1. To touch on several of the key features of basic Rails apps, such as authorization and search.
2. To learn how to collaborate on an app and use proper TDD and git workflows.

Expect it to be challenging! Collaboration can be tough, both organizationally and personally. Treat this project as an opportunity to strengthen your communication and organization skills. Employers value developers who can communicate well with others and are patient and good-natured with their team members.

### Requirements

At a minimum, you must supply the following functionality:

* The ability to add an item to be reviewed.
* The ability to rate the item and to optionally comment on it (i.e. write a review).
* The ability to upvote or downvote a review. A user can only upvote or downvote once and can change their vote from up to down.
* A sign up and authentication system for your users (with Devise).
* An ability to upload a profile photo (with Carrierwave).
* The ability to search for items.
* An admin role. Admins are able to delete comments or items if they are deemed to be inappropriate.
* An email is sent to the owner of an item when a new review is posted about it.
* Pagination (with Kaminari).

Each of these features will be described in more detail below, but many of them will require you to do some independent research - read gem documentation, watch RailsCasts, etc. Embrace the challenge! You'll need those research skills as a developer after Launch Academy.

### Getting Started

With your group, decide what item you want to review.

Write an initial set of user stories and acceptance criteria. Have those user stories and acceptance criteria reviewed by the Experience Engineer overseeing your project.

Then, create an ER diagram with your group. Review it with Experience Engineer overseeing your project, and revise as needed prior to writing any code.

### User Authentication

Very often, the first place we'll start when writing an app is the `User` model.  Most of our apps will require users to create accounts and login to access many of the key features.

#### Authentication User Stories

Your implementation should fulfill the following user stories:

```no-highlight
As a prospective user
I want to create an account
So that I can post items and review them
```

```no-highlight
As an authenticated user
I want to update my information
So that I can keep my profile up to date
```

```no-highlight
As an authenticated user
I want to delete my account
So that my information is no longer retained by the app
```

```no-highlight
As an unauthenticated user
I want to sign in
So that I can post items and review them
```

```no-highlight
As an authenticated user
I want to sign out
So that no one else can post items or reviews on my behalf
```

#### Authentication Implementation

In Rails, we can use a gem called [Devise](https://github.com/plataformatec/devise) to create our `User` model for us.  It takes care of user authentication, security, forgotten passwords, and the like.  Devise is widely used and well-tested, so we shouldn't need to worry about the security of our users' data.

You can utilize our Rails app generator `make_it_so` to get started with a baseline application that includes Devise and Foundation.

```bash
$ gem install make_it_so
$ make_it_so rails <directory_name>
```

### CRUD Behavior

Now that we have users, it's time to add the item we want to review. We'll want to write user stories for each CRUD action that we want to complete for a review.

CRUD is an acronym representing the major database operations we might want to perform for a particular model.  It stands for:

* Create  (add a record to the databse)(A user adds an item to the database)
* Read (retrieve information about items from the database)(A user views a list of items, or the page for a particular item)
* Update (edit an item's information) (A user edits an item's information)
* Delete (delete an item from the database)(A user deletes an item)

#### CRUD User Stories

In a standard CRUD app, each of these CRUD operations will correspond to one (or, for "read", two) user stories:

* Create

```no-highlight
As an authenticated user
I want to add an item
So that others can review it
```

* Read

```no-highlight
As an authenticated user
I want to view a list of items
So that I can pick items to review
```

```no-highlight
As an authenticated user
I want to view the details about an item
So that I can get more information about it
```

* Update

```no-highlight
As an authenticated user
I want to update an item's information
So that I can correct errors or provide new information
```

* Delete

```no-highlight
As an authenticated user
I want to delete an item
So that no one can review it
```

**Note:** You may decide that you want certain features (such as viewing a list of items) to be available to unauthenticated users, or non-users who visit the site.  In that case, you can modify the first line of the relevant user story to reflect that.

#### CRUD Implementation

Choose one pair in your group to complete the CRUD user stories for the item you want to review.

While that pair is working, the second pair can begin on the CRUD user stories for the `Review` model (see the next assignment). Simply leave off the `item_id` and association with the `Item` model until the first group's Pull Request has been merged into master.  Then you can add in the foreign key and association between the two models.

#### Modify the User Stories

Tailor the user stories above to suit your app and add acceptance criteria to further guide your implementation.

Acceptance criteria should specify the following, at a minimum:

* What conditions must be met for the task to be completed.
  * Ex. "I must be logged in to add an item."
* Which fields are required.
  * Ex. "I must provide an item name and description."
* Which fields are optional.
  * Ex. "I may optionally provide the item's website."
* What happens in the case of an error.
  * Ex. "If I do not supply the required information, I receive an error message."
  * Ex. "If an item with that name is already in the database, I receive an error message."

#### Create a New Feature Branch

Create a new branch prefixed with your initials, for example:

```no-highlight
$ git branch hh-fs-add-<item_name>-model
```

#### Write an Acceptance Test

Before you begin your implementation for each user story, write an acceptance test for it.

#### Create a Pull Request

Push up your branch to GitHub and create a Pull Request.  Consult your EE project mentor for guidance on how to create a Pull Request.

### Reviewing Items

While the first pair is working on adding your `Item` model, the second pair can start in on the CRUD user stories for reviews.

Using the examples in the last assignment, write user stories and acceptance criteria for reviews.

Your user stories should cover:

* A user adding a review
* A user viewing a list of reviews for an item
* A user updating a review
* A user deleting a review

Before writing any code for this feature, create a new branch in your repository. Then write an acceptance test for the review functionality before implementing it.

Once the feature is complete, open a pull request on GitHub to merge it back into master. Ensure that the pull request is reviewed by your mentor **before** it is merged into the master branch.

#### A Note on Dependencies

Obviously, you want your `Review` to be associated with a particular `Item` that is being reviewed.  However, your `Item` model may well not exist yet, since your other pair is probably working on it right now!

Because you don't have an `Item` model, you shouldn't add the `item_id` foreign key and association straightaway, because that would introduce broken code into your app:

```ruby
review = Review.first
review.item # this will break without an Item model
```

Instead, we can leave off our association and include an `item_name` field on our `reviews` table instead of an `item_id` foreign key.  Once the items Pull Request has been merged into master, you can update your acceptance tests, change the `item_name` column to a foreign key, and add the association.

Consult with your mentor for further guidance on this workflow.

### Voting

Now that we've got items and reviews, it's time to let users vote on reviews.

Write user stories and acceptance criteria to cover the following situations:

* A user votes on a review
* A user changes their vote
* A user deletes their vote

Make sure a user can only vote once per review.

As before, start by checking out a new feature branch.  Write an acceptance test, make the test pass, and repeat until your user stories are complete.  Create a Pull Request containing your completed code.

### Administrators

Many web apps have separate admin sections that allow admins to perform tasks that regular users cannot. Let's give admins the ability to delete inappropriate items or reviews, or obnoxious users' accounts.

Write user stories and acceptance criteria to cover the following situations:

* An admin views a list of users
* An admin deletes a user
* An admin deletes an item
* An admin deletes a review

Follow the git and TDD workflow you've established when completing prior features.

#### Hints

There are two general approaches to implementing admin functionality: add conditional statements to existing views and controllers to check for admin privileges or define a separate set of views/controllers only accessible to admins.

Adding conditional checks for admins to existing views may look something like:

```html
<% @items.each do |item| %>
  <!-- some stuff here -->

  <% if current_user.admin? %>
    <%= button_to 'Delete', item, method: :delete %>
  <% end %>
<% end %>
```

Merely hiding a button or creating a separate view does not prevent malicious users from performing admin-only actions, such as triggering our `ItemsController#destroy` action. Malicious users could still delete records by sending hand-crafted HTTP requests to delete the record directly. Ensure that you have the appropriate checks in your controller to ensure that the authenticated user has the appropriate permissions to perform certain actions.

An alternative is to using **namespacing** to define a set of routes and controllers that are only accessible to admin users:

```ruby
namespace :admin do
  resources :items
end
```

With separate controllers and views you can simplify the authorization checks by only allowing admins to view any portion of the page.

### Profile Photos

Use the [Carrierwave](https://github.com/carrierwaveuploader/carrierwave) gem to allow users to upload profile photos when they create or edit their accounts.  We'll use Carrierwave in combination with the [fog](https://github.com/fog/fog) gem to allow us to save profile photos on Amazon S3.

If you're feeling ambitious, you can also use Carrierwave to allow users to upload photos of whatever items your app reviews.

Because we already have user stories for creating and updating user profiles, you can simply modify those user stories to allow users to optionally provide a profile photo.

Try to follow the Carrierwave and fog documentation to implement this feature.  Learning to use a new gem by reading the docs is an important skill that you'll rely on frequently once you leave Launch.

#### Hints

One member of your group will need to create an Amazon AWS account and an S3 bucket to store the photos. S3 provides cheap storage and AWS offers free tier for new users of up to 1GB for a year but they require a credit card to sign up. You'll then need to store your AWS credentials and S3 bucket name(s) as environment variables inside your app using the [dotenv-rails](https://github.com/bkeepers/dotenv) gem.

**Make sure not to commit these credentials!** If your credentials get pushed to GitHub and some nefarious person and/or bot gets ahold of them, they can rack up a nasty bill on your AWS account.

* The dotenv gem will have you store your credentials in a file called `.env`.  Make sure to add this to your `.gitignore` file before committing so that any changes you make to that file (e.g., adding your actual credentials) don't get committed and pushed to GitHub.
* Create a file called `.env.example` that contains the names of any environment variables a collaborator would need to set in order to use the app.

As an example, you should have the following in your `.gitignore`, `.env`, and `.env.example` files:

```no-highlight
# in /.gitignore:
/.env

# in /.env:
AWS_ACCESS_KEY_ID=<your actual AWS access key id>
AWS_SECRET_ACCESS_KEY=<your actual AWS secret access key>
S3_BUCKET=<the name of your S3 bucket>

# in /.env.example:
AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
S3_BUCKET=
```

### Pagination

Add pagination to the application to limit the number of items or reviews that are displayed on a single page. Use [Kaminari](https://github.com/amatsuda/kaminari) to paginate your items' index page and the reviews on your items' show pages, as well as anywhere else in your app that you think it would be useful.

Pagination isn't really a new feature, so we don't need separate user stories.  Since we're modifying what users see on the items index and show pages, we can modify the existing user stories for those pages to add acceptance criteria regarding how many items are displayed.

Try to follow the Kaminari documentation to implement this feature.  Learning to use a new gem by reading the docs is an important skill that you'll rely on frequently once you leave Launch.

### Search

Add a search bar that allows users to search for items.

Write a user story and acceptance criteria for this feature.

Take some time to try to figure out how to do this on your own.

If you're stuck, consult past Sinatra apps that had search functionality, or [this Railscast](http://railscasts.com/episodes/37-simple-search-form) or [this blog article](http://www.stefanosioannou.com/rails-4-simple-search-form/).

### Email

Integrate email into your app using ActionMailer. Email the user who posted an item when someone posts a review of that item.  (Alternatively, or in addition, email reviewers when their reviews are up- or downvoted.)

Write a user story and acceptance criteria for this feature.

**NOTE:** When you deploy to Heroku, you'll need to set up an add-on to allow you to send email in production using ActionMailer.  We recommend [Mandrill](https://devcenter.heroku.com/articles/mandrill).
