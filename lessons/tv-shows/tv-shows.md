**Acceptance tests** are high-level tests that essentially walk through an application as though they were a user. Our acceptance tests will read like a script of a user interacting with our application, ensuring that acceptance criteria is met along the way. We might have a test that walks through a user signing up for our app, adding a record to the database, or viewing a particular item's page.

As test-driven developers, we start our development process by writing an acceptance test, so that's the first kind of test we'll cover.

### Learning Goals

* Use outside-in development to build a simple Rails app.

### Instructions

Use acceptance testing to drive implementation of some features on an app that lets you track your favorite TV shows.

To get started, run the following commands to install any dependencies and setup the database:

```no-highlight
$ bundle
$ rake db:create
$ rake db:migrate
```

Now run `rake spec`. All of your tests should be passing.

Take a look in the `spec/features` directory. You should see that tests have already been written for:

* viewing the TV shows index page
* viewing a TV show's show page
* adding a TV show

These tests should be passing: users can add and view TV shows. Now they want a way to add their favorite characters associated with those TV shows. They also want to be able to view a list of all the characters in the database, as well as see all of a TV show's characters on that show's page.

Add acceptance tests and the feature implementation to satisfy the following user stories:

#### Add a Character

```no-highlight
As a site visitor
I want to add my favorite TV show characters
So that other people can enjoy their crazy antics

Acceptance Criteria:
* I can access a form to add a character on a TV show's page
* I must specify the character's name and the actor's name
* I can optionally provide a description
* If I do not provide the required information, I receive an error message
* If the character already exists in the database, I receive an error message
```

**Hint:** Only one character with a particular name should be able to exist in the database for any given TV show.

#### View a List of Characters

```no-highlight
As a site visitor
I want to view a list of people's favorite TV characters
So I can find wonky characters to watch

Acceptance Criteria:
* I can see a list of all the characters
* The character's name and the TV show it is associated with are listed
```

#### View Character Information on TV Show's Page

```no-highlight
As a site visitor
I want to view the details for a TV show
So I can learn more about it

Acceptance Criteria:
* I can see a the show's title, network, the years it ran, and a synopsis
* For each character, I can see the character's name, actor's name, and the character's description
```

**Hint:** You can modify an existing acceptance test for this user story.

#### Delete a Character

```no-highlight
As a site visitor
I want to delete a character I don't like
So no one else will want to watch that character

Acceptance Criteria:
* I can delete a character from the database
* If the record is successfully deleted, I receive an notice that it was deleted
```

### Tips

Start with the first user story and practice outside in development.

* Draw out your ER diagram. What models do we have or need? What attributes do those models have? What are the associations between the models?
* Write a failing acceptance test for the right/happy path of creating a new character.
* Get the failing acceptance test you wrote to pass. Run `rake spec` and make a note of the error message you receive. Write just enough code to get past that error message. Then run `rake spec` again and repeat.
* Write a failing acceptance test for the situation where a user does not specify the required information.
* Get your failing acceptance test to pass as above.

**Do not** worry about authorization or authentication at this time. Assume that any user can view all the pages of the app and add or delete information at will.

### Additional Challenge

In the user stories above, we saved the actor's name as an attribute on the `Character` model. Now we want to be able to track our favorite actors, as well, so we need to extract that attribute into its own `Actor` model.

Write acceptance tests (and modify existing acceptance tests as necessary) and test-drive the following features:

* adding an actor
* viewing an actor's show page
* viewing an actors index page

The actor's show page should list all of the characters the actor has played, along with the TV show that character was in.
