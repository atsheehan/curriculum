In this challenge you'll build a website like [stackoverflow.com](http://stackoverflow.com/) for posting questions and answers.

### Prerequisites

**If you're not yet comfortable with the basics of Rails, please go through the official [Getting Started with Rails](http://guides.rubyonrails.org/getting_started.html) guide.**

### Learning Objectives

- Build a Rails app
- Compare Rails to Sinatra
- Practice using Rails routes
- Practice using Rails form helpers
- Practice using Active Record associations

### Resources

- [Getting Started with Rails](http://guides.rubyonrails.org/getting_started.html)
- [Rails Routing from the Outside In](http://guides.rubyonrails.org/routing.html)
- [Rails Form Helpers](http://guides.rubyonrails.org/form_helpers.html)
- [Active Record Query Interface](http://guides.rubyonrails.org/active_record_querying.html)
- [Active Record Associations](http://guides.rubyonrails.org/association_basics.html)
- [Working with Validation Errors](http://edgeguides.rubyonrails.org/active_record_validations.html#working-with-validation-errors)
- [Displaying Errors in Views](http://edgeguides.rubyonrails.org/active_record_validations.html#displaying-validation-errors-in-views)

### Hints

* When creating a migration in Rails you can use a Rails generator command rather than `rake db:create_migration`. The format of the command is `rails generate migration <name_of_migration>`. For example, to create a migration to add a `questions` table you might run:

```no-highlight
$ rails generate migration create_questions
    invoke  active_record
    create    db/migrate/20140612171601_create_questions.rb
```

* Creating forms in Rails requires a bit of extra setup. Rather than hardcoding the `<form>` element in HTML you can use the `form_for` helper method in your views. You can read about the `form_for` helper [here][forms_for_models].

* Use Git to save the state of your code each time you complete a user story (or more often if it's a complex user story). Try using Git branches to store all commits related to a particular feature and then merge back into *master* when the feature is complete.

### Getting Started

Start with a new Rails application configured with PostgreSQL:

```no-highlight
# Generate a new Rails app that is set up for PostgreSQL and skips test setup
$ rails new rescue_mission --database=postgresql --skip-test-unit --skip-turbolinks
$ cd rescue_mission
$ git init
$ git add -A
$ git commit -m 'Initial commit'
```

### User Stories

The application should support the following user stories. Review all of the user stories before beginning to get a sense of the scope of the project. Consider how you'll structure information within the database and sketch an initial ER diagram.

Once you've reviewed the user stories below, implement **one user story at a time**. It is important to work incrementally and verify that a user story is complete before tackling the next one.

The user stories are ordered by increasing complexity and should build on top of each other. Note that the first user stories depend on viewing questions without having a form to create them. In this case you can use `rails console` or `psql rescue_mission_development` to directly add questions to the database for testing purposes.

#### View All Questions

```no-highlight
As a user
I want to view recently posted questions
So that I can help others

Acceptance Criteria

- I must see the title of each question
- I must see questions listed in order, most recently posted first
```

#### View a Question's Details

```no-highlight
As a user
I want to view a question's details
So that I can effectively understand the question

Acceptance Criteria

- I must be able to get to this page from the questions index
- I must see the question's title
- I must see the question's description
```

#### Post a Question

```no-highlight
As a user
I want to post a question
So that I can receive help from others

Acceptance Criteria

- I must provide a title that is at least 40 characters long
- I must provide a description that is at least 150 characters long
- I must be presented with errors if I fill out the form incorrectly
```

#### Answering a Question

```no-highlight
As a user
I want to answer another user's question
So that I can help them solve their problem

Acceptance Criteria

- I must be on the question detail page
- I must provide a description that is at least 50 characters long
- I must be presented with errors if I fill out the form incorrectly
```

#### Viewing a Question's Answers

```no-highlight
As a user
I want to view the answers for a question
So that I can learn from the answer

Acceptance Criteria

- I must be on the question detail page
- I must only see answers to the question I'm viewing
- I must see all answers listed in order, most recent last
```

#### Editing a Question

```no-highlight
As a user
I want to edit a question
So that I can correct any mistakes or add updates

Acceptance Criteria

- I must provide valid information
- I must be presented with errors if I fill out the form incorrectly
- I must be able to get to the edit page from the question details page
```

#### Deleting a Question

```no-highlight
As a user
I want to delete a question
So that I can delete duplicate questions

Acceptance Criteria

- I must be able delete a question from the question edit page
- I must be able delete a question from the question details page
- All answers associated with the question must also be deleted
```

### Non-core User Stories

#### Markdown Support

```no-highlight
As a user
I want to write my questions and answers with markdown
So I can easily format my questions and answers

Acceptance Criteria

- I can write my questions and answers using markdown syntax
- Questions and answers, when shown, should be the HTML rendered from the
  markdown
```

#### Choosing an Answer

```no-highlight
As a user
I want to mark an answer as the best answer
So that others can quickly find the answer

Acceptance Criteria

- I must be on the question detail page
- I must be able mark an answer as the best
- I must see the "best" answer above all other answers in the answer list
```

#### User Authentication

```no-highlight
As a user
I want to sign in
So that my questions and answers can be associated to me

Acceptance Criteria

- I must be able to sign in using either GitHub, Twitter, or Facebook (choose
  one)
```

#### User Signs Out

```no-highlight
As a user
I want to be able to sign out
So that other users of my computer can't pretend to be me

Acceptance Criteria

- I must be able to sign out from any page
```

#### Prevent Users From Editing Other Another User's Questions

```no-highlight
As a user
I want to prevent other users from editing my questions
So that malicious users can't mess with my question

Acceptance Criteria

- I must be signed in
- I must be able to edit a question that I posted
- I can't edit a question that was posted by another user
```

#### Prevent Users Choosing "Best" Answer for Another User's Questions

```no-highlight
As a user
I want to prevent other users from choosing the "best" answer for my question
So that malicious users can't mess with my question

Acceptance Criteria

- I must be signed in
- I must be able to choose the "best" answer for a question that I posted
- I can't choose the best answer for a question that was posted by another user
```

#### Prevent Users Choosing Deleting Another User's Question

```no-highlight
As a user
I want to prevent other users from deleting my question
So that malicious users can't mess with my question

Acceptance Criteria

- I must be signed in
- I must be able to delete a question that I posted
- I can't delete a question that was posted by another user
```

[forms_for_models]: http://guides.rubyonrails.org/form_helpers.html#dealing-with-model-objects
