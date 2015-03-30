In this article we'll discuss how to use FactoryGirl to build a complex record hierarchy with a single method call.

### Learning Goals

* Define associations within FactoryGirl
* Create multiple records from one factory
* Refactor a test with associations

### Implementation Notes

Very rarely do our models exist in a vacuum. It wouldn't make much sense to write a product review if you did not have product to attach it to. The review depends on the existence of these other models for it to have any meaning.

When we're writing our tests, we often have to consider what records we'll need to create in addition to the one that we're testing. If we were testing our review model, we'd have to ensure that we created the record for the product that we're reviewing as part of the test.

For complex associations with many records this can be quite tedious. We'll see how we can define associations within FactoryGirl to remove some of the setup required and focus in on only the record we're interested in.

### Setup

For this article we'll use an application that stores book reviews. We can check out a copy of the application with the models and associations already defined for us:

```no-highlight
$ git clone git@github.com:LaunchAcademy/book_reviews.git
```

We'll then need to install the necessary gems (via Bundler) and create our databases:

```no-highlight
$ cd book_reviews
$ bundle
$ rake db:create
$ rake db:migrate
```

Before we start writing tests, let's first take a look at our schema.

### Book Reviews

The schema for our application defines models for users, books, authors, and reviews. When studying a new rails app, `db/schema.rb` can give us a good understanding of the application's database structure.

A book belongs to an author and books can have many reviews. Each review also belongs to a single user.

Most of the attributes have a `NOT NULL` constraint (i.e. `null: false` in ActiveRecord) that requires each record to specify those values. This means that if we wanted to create a book review, we need to specify the body and rating as well as the book it belongs and the user. But a book also belongs to an author, so before we can create our book we need to create an author. This might look something like the following:

```ruby
author = Author.create!(name: "Shel Silverstein")
book = Book.create!(title: "The Giving Tree", published_at: "1964-10-07", author: author)

user = User.create!(username: "dr_seuss")
review = Review.create!(rating: 1, body: "Trite. Lacks depth.", user: user, book: book)
```

We have to create three records (an author, a book, and a user) before we could construct our review record. This is a lot of overhead if we only really care about the contents of the review.

### Most Recent Reviews

To see how FactoryGirl can simplify our lives, we're going to test-drive a method for viewing the most recent reviews written by a user.

We'll add this method on the User model. For our test, we'll want to create a few different book reviews from the same user with different timestamps (i.e. `created_at`). We want to assert that when we ask for the most recent reviews, it will return the books ordered by that timestamp. We can go ahead and add the following test to `spec/models/user_spec.rb`:

```ruby
require "rails_helper"

describe User do
  describe "#recent_reviews" do
    it "returns the most recent reviews ordered by creation time" do
      user = User.create!(username: "test_user")

      first_author = Author.create!(name: "Author 1")
      second_author = Author.create!(name: "Author 2")
      third_author = Author.create!(name: "Author 3")

      first_book = Book.create!(title: "Book 1",
        published_at: "2000-10-07", author: first_author)
      second_book = Book.create!(title: "Book 2",
        published_at: "1983-10-07", author: second_author)
      third_book = Book.create!(title: "Book 2",
        published_at: "1992-10-07", author: third_author)

      oldest_review = Review.create!(rating: 1, body: "foo",
        user: user, book: first_book, created_at: "2012-04-04")
      newest_review = Review.create!(rating: 2, body: "bar",
        user: user, book: second_book, created_at: "2013-07-01")
      middle_review = Review.create!(rating: 3, body: "baz",
        user: user, book: third_book, created_at: "2013-02-12")

      expect(user.recent_reviews).to eq([newest_review, middle_review, oldest_review])
    end
  end
end
```

This is a lot of code, but it's really just creating three reviews and making sure that when we call `recent_reviews`, we get the reviews in the order that they were created. We can get this test to pass by adding a new instance method `recent_reviews` to our User class in `app/models/user.rb`:

```ruby
class User < ActiveRecord::Base
  has_many :reviews

  validates :username, presence: true

  def recent_reviews
    reviews.order(created_at: :desc)
  end
end
```

Running the test suite should show that everything is passing.

### Refactoring Our Tests

We have our test passing, but the test code itself is still a bit of a mess. Let's see if we can define some factories to simplify this a bit. We can start by defining a factory for each of the models that we're using in `spec/factories.rb` with some generic attributes:

```ruby
FactoryGirl.define do

  factory :user do
    username "majortom"
  end

  factory :author do
    name "Dr. Seuss"
  end

  factory :book do
    title "Green Eggs and Ham"
    published_at "1960-08-12"
  end

  factory :review do
    body "A++++ would read again!!!!!!!!"
    rating 10
  end

end
```

Now, we can use these factories in our unit test to remove a little bit of code:

```ruby
require "rails_helper"

describe User do
  describe "#recent_reviews" do

    it "returns the most recent reviews ordered by creation time" do
      user = FactoryGirl.create(:user)

      first_author = FactoryGirl.create(:author)
      second_author = FactoryGirl.create(:author)
      third_author = FactoryGirl.create(:author)

      first_book = FactoryGirl.create(:book, author: first_author)
      second_book = FactoryGirl.create(:book, author: second_author)
      third_book = FactoryGirl.create(:book, author: third_author)

      oldest_review = FactoryGirl.create(:review, user: user,
        book: first_book, created_at: "2012-04-04")
      newest_review = FactoryGirl.create(:review, user: user,
        book: second_book, created_at: "2013-07-01")
      middle_review = FactoryGirl.create(:review, user: user,
        book: third_book, created_at: "2013-02-12")

      expect(user.recent_reviews).to eq([newest_review, middle_review, oldest_review])
    end
  end
end
```

This looks a little better, but there is still a lot of setup required that clutters the purpose of the test. We don't care about the name of the author or the book or when it was published, we just need those records to exist in our database. It would be nice if we had some sort of tool that would create those for us automatically when we asked for a new review object.

### FactoryGirl Associations

If we look at the previous test we wrote, we didn't specify any custom attributes for the authors we created:

```ruby
author = FactoryGirl.create(:author)
book = FactoryGirl.create(:book, author: author)
```

Each book receives a generic author. In fact, we could have rewritten this inline since we don't use the author anywhere else:

```ruby
book = FactoryGirl.create(:book, author: FactoryGirl.create(:author))
```

FactoryGirl can handle building the associated records for us if we include them as part of the factory definition. The `author` attribute is really a reference to a separate record in the `authors` table so we have to tell FactoryGirl that this attribute is an `association`. Let's update our `spec/factories.rb` with the following definition for a book:

```ruby
factory :book do
  title "Green Eggs and Ham"
  published_at "1960-08-12"

  association :author, factory: :author
end
```

Now when we run `FactoryGirl.create(:book)` we'll get two records: the author and the book. Let's refactor our test to incorporate this change:

```ruby
require "rails_helper"

describe User do
  describe "#recent_reviews" do

    it "returns the most recent reviews ordered by creation time" do
      user = FactoryGirl.create(:user)

      first_book = FactoryGirl.create(:book)
      second_book = FactoryGirl.create(:book)
      third_book = FactoryGirl.create(:book)

      oldest_review = FactoryGirl.create(:review, user: user,
        book: first_book, created_at: "2012-04-04")
      newest_review = FactoryGirl.create(:review, user: user,
        book: second_book, created_at: "2013-07-01")
      middle_review = FactoryGirl.create(:review, user: user,
        book: third_book, created_at: "2013-02-12")

      expect(user.recent_reviews).to eq([newest_review, middle_review, oldest_review])
    end
  end
end
```

If we run this we should still have a green test suite. Notice how we don't have to mention the author anywhere. We don't care about who the author was for this test, we only care about the book reviews. And by relegating the task of creating the author to FactoryGirl we reduce a bit of the clutter in our tests.

We've updated our book factory but we really are working with reviews for this test. Let's update the review factory in the `spec/factories.rb` file to include the associations shown here:

```ruby
factory :review do
  body "A++++ would read again!!!!!!!!"
  rating 10

  association :book, factory: :book
  association :user, factory: :user
end
```

Now when we run `FactoryGirl.create(:review)`, we're actually getting four records: the review itself, the book being reviewed, the author of the book, and the user writing the review. Very handy.

For our test, we now just need to create the user and the reviews and the rest will be taken care of. Let's refactor `spec/models/user_spec.rb`:

```ruby
require "rails_helper"

describe User do
  describe "#recent_reviews" do

    it "returns the most recent reviews ordered by creation time" do
      user = FactoryGirl.create(:user)

      oldest_review = FactoryGirl.create(:review, created_at: "2012-04-04")
      newest_review = FactoryGirl.create(:review, created_at: "2013-07-01")
      middle_review = FactoryGirl.create(:review, created_at: "2013-02-12")

      expect(user.recent_reviews).to eq([newest_review, middle_review, oldest_review])
    end
  end
end
```

If we run this test again, it should fail. Calling `user.recent_reviews` returns an empty result set rather than the three reviews we created.

Since we added the `user` association to the review factory, each review will create a brand new user. What we want instead is to use the initial user we create at the start of our test. In FactoryGirl we can override attributes in the `create` call, including associations. Since we already have a `user` record, we can just pass that into the create calls:

```ruby
require "rails_helper"

describe User do
  describe "#recent_reviews" do

    it "returns the most recent reviews ordered by creation time" do
      user = FactoryGirl.create(:user)

      oldest_review = FactoryGirl.create(:review, user: user, created_at: "2012-04-04")
      newest_review = FactoryGirl.create(:review, user: user, created_at: "2013-07-01")
      middle_review = FactoryGirl.create(:review, user: user, created_at: "2013-02-12")

      expect(user.recent_reviews).to eq([newest_review, middle_review, oldest_review])
    end
  end
end
```

Running this test again should show green.

#### Simplified Syntax

When we have associations that have the same name as the factory, we can use a simpler syntax in FactoryGirl. For our book factory, the author association could be reduced from `association :author, factory: :author` to simply `author`:

```ruby
factory :book do
  title "Green Eggs and Ham"
  published_at "1960-08-12"

  author
end
```

FactoryGirl will see the author attribute and look for a factory named `author` to build the association. We could change the rest of our factories to use this concise syntax as well:

```ruby
FactoryGirl.define do

  factory :user do
    username "majortom"
  end

  factory :author do
    name "Dr. Seuss"
  end

  factory :book do
    title "Green Eggs and Ham"
    published_at "1960-08-12"

    author
  end

  factory :review do
    body "A++++ would read again!!!!!!!!"
    rating 10

    book
    user
  end

end
```

In some cases the factory will differ from the name of the association, in which case we can use the other `association :association_name, factory: :factory_name` syntax.

### Resources

* [FactoryGirl Associations Guide](https://github.com/thoughtbot/factory_girl/blob/master/GETTING_STARTED.md#associations)
