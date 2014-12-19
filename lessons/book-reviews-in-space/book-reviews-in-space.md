### Overview

You're going to be building a website like
[goodreads.com](http://www.goodreads.com/) so astronauts can post books and review them.

### Prerequisites

** The Rails guides are an excellent resource for many of the questions that may come up in this assignment:
[Getting Started with Rails](http://guides.rubyonrails.org/getting_started.html)**

### Learning Objectives

- Build a basic Rails app
- Learn how to implement the Devise gem
- Practice using Rails routes
- Practice using Rails form helpers
- Practice using Active Record associations
- Practice TDD

### Hints
Draw an ER diagram for your app first.

Then, implement the [Devise](https://github.com/plataformatec/devise) gem to generate the User model for you. After installing Devise, you will have to add a column "role" to your Users table. The default role is "candidate" which a user can later update to "astronaut." Feel free to experiment and add any other fields you think make sense (maybe "favorite book" or "favorite author," for example).

Work through the rest of the user stories once you have implemented Devise.

Write tests for your features!

### Resources

- [Getting Started with Rails](http://guides.rubyonrails.org/getting_started.html)
- [Rails Routing from the Outside In](http://guides.rubyonrails.org/routing.html)
- [Rails Form Helpers](http://guides.rubyonrails.org/form_helpers.html)
- [Active Record Query Interface](http://guides.rubyonrails.org/active_record_querying.html)
- [Active Record Associations](http://guides.rubyonrails.org/association_basics.html)
- [Working with Validation Errors](http://edgeguides.rubyonrails.org/active_record_validations.html#working-with-validation-errors)
- [Displaying Errors in Views](http://edgeguides.rubyonrails.org/active_record_validations.html#displaying-validation-errors-in-views)

### Getting Started

```no-highlight
# Generate a new Rails app that is set up for PostgreSQL and skips test setup
rails new book_reviews_in_space --database=postgresql -T
```

### User Registration and Devise

```no-highlight
As a prospective user
I want to create an account
So that I can post books and review them

```no-highlight
As an authenticated user
I want to delete my account
So that my information is no longer retained by the app
```

```no-highlight
As an authenticated user
I want to see my profile page
So that I can change information on it
```

```no-highlight
As an authenticated user
I can change my role on my profile page to astronaut
So I can post books and review them as an astronaut
```

```no-highlight
As an unauthenticated user
I want to sign in
So that I can post books and review them
```

```no-highlight
As an authenticated user
I want to sign out
So that no one else can post books or reviews on my behalf
```

#### Post a Book

```no-highlight
As a user
I want to post a link to a book
So I can share what I'm reading with others

Acceptance Criteria

- I must provide a title that is at least 1 character long
- I must provide a description that is at least 10 characters long
- I must provide a valid URL to the book
- I must be presented with errors if I fill out the form incorrectly
```

#### View All Books

```no-highlight
As a user
I want to view recently posted books
So that I can see what others are reading

Acceptance Criteria

- I must see the title of each book
- I must see the description of each book
- I must see the URL of each book
- I must see books listed in order, most recently posted first
- I must see if a book was posted by an astronaut or a candidate
```

#### View a Book's Details

```no-highlight
As a user
I want to view a book's details
So that I can see a book's details

Acceptance Criteria

- I must be able to get to this page from the books index
- I must see the book's title
- I must see the book's description
- I must see the book's URL
```

#### Reviewing a Book

```no-highlight
As a user
I want to review a book
So I can let other users know what I thought about it

Acceptance Criteria

- I must be on the book detail page
- I must provide a description that is at least 50 characters long
- I must be presented with errors if I fill out the form incorrectly
```

#### Viewing a Book's Reviews

```no-highlight
As a user
I want to view the reviews for a book
So that I can see what people are saying about it

Acceptance Criteria

- I must be on the book detail page
- I must only see reviews to books I'm viewing
- I must see all reviews listed in order, most recent first
- I must see if the writer of the review is a candidate or an astronaut
```

#### Editing a Review

```no-highlight
As a user
I want to edit a review
So that I can correct any mistakes or add updates

Acceptance Criteria

- I must provide valid information
- I must be presented with errors if I fill out the form incorrectly
- I must be able to get to the edit page from the question details page
```

#### Deleting a Review

```no-highlight
As a user
I want to delete a review
So that I can delete my review if I no longer want to show it

Acceptance Criteria

- I must be able delete a review from the review edit page
- I must be able delete a review from the review details page
```

#### Deleting a Book

```no-highlight
As a user
I want to delete a book I posted
So that I can delete a book I posted for any reason

Acceptance Criteria

- I must be able delete a book from the book details page
- All reviews associated with the book must also be deleted
```

[forms_for_models]: http://guides.rubyonrails.org/form_helpers.html#dealing-with-model-objects
