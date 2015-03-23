### Contents

The screencasts provided will walk you through the development of the following user stories. We will cover TDD with Capybara, as well as user authentication with the Devise gem. You will get the most out of this series by following along and building the app with us.

[Game Collector Repository](https://github.com/LaunchAcademy/game_collector/tree/screencast)

### Videos
#### Intro - Setting Up a Rails App
<div class="video-wrapper">
<iframe src="//player.vimeo.com/video/113656290" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>
</div>
##### Topics Covered:
* explaining the `rails new` command
* adding Gems to the Gemfile
  - pry-rails
  - rspec-rails
  - capybara
* following the [rspec-rails](https://github.com/rspec/rspec-rails) and [capybara](https://github.com/jnicklas/capybara) documentation

#### Part 1 - Getting Started With BDD/TDD in Capybara
<div class="video-wrapper">
<iframe src="//player.vimeo.com/video/114592873" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>
</div>
##### Topics Covered:
* creating the `features` folder
* creating a feature spec that ends with `_spec.rb`
* using Capybara methods to interact with a form
* running the test suite with `rake spec`
* seeing available routes with the `rake routes` command
* adding Routes, Controller methods, and Views
* using `form_for` helpers
* strong params
* using `save_and_open_page` from the [launchy gem](https://github.com/copiousfreetime/launchy)
* reading the [railsguides](http://guides.rubyonrails.org/) and [apidocs](http://apidock.com/rails)
* following the "Happy Path" when writing a test

#### Part 2 - Testing Edge Cases and Validation Messages
<div class="video-wrapper">
<iframe src="//player.vimeo.com/video/114592874" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>
</div>
##### Topics Covered:
* ActiveRecord validations
* testing validation error messages
* ActiveRecord migrations for adding null: false
* using Acceptance Criteria as a guide to determine if we have completed a feature

#### Part 3 - Testing the Board Games Index Page
<div class="video-wrapper">
<iframe src="//player.vimeo.com/video/114592875" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>
</div>
##### Topics Covered:
* creating multiple records in a test
* testing the view for the presence of Board Game names

#### Part 4 - Implementing User Authentication with Devise
<div class="video-wrapper">
<iframe src="//player.vimeo.com/video/114592876" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>
</div>
##### Topics Covered:
* following the [Devise documentation](https://github.com/plataformatec/devise) step-by-step.
* branching with git
* setting up the `spec_helper.rb` to be able to scope tests with `focus: true`

## User Stories (Screencasted)

### Input a Board Game
```no-highlight
As a 7th Level Dungeon Master
I want to save the details of a board game that I own
So that I can have a digital record of it.
```

#### Acceptance Criteria
- [ ] I must enter a name, publisher, description, and release_date
- [ ] If all fields are complete, I am told that my board game has been saved
- [ ] If a field is incomplete, I am given an error message and brought back to the input form.
- [ ] If a board game already exists in the database, I am given an error message.

### View a List of Board Games
```no-highlight
As a visitor of the Game Collector website
I want to see a list of board games
So that I can learn about awesome games.
```

#### Acceptance Criteria
- [ ] If I navigate to the /board_games path, I should see a list of games.

### User Sign Up
```no-highlight
As a Board Game Fanboy (or Fangirl)
I want to sign up for the Game Collector application
So that I can use all of its awesome features.
```

#### Acceptance Criteria
- [ ] There is a link to 'Sign Up' on the homepage.
- [ ] If I fill in my first name, last name, email, password, and password confirmation correctly, I am greeted with a confirmation message that my account has been created.
- [ ] If the password and password confirmation fields do not match, I am given an error message.
- [ ] If my email already exists in the database, I am given a message that tells me I have already registered.
- [ ] If my email is not formatted correctly, I am given an error message.

### User Sign In
```no-highlight
As a Officially Registered Game Collector user
I want to sign in
So that I can see my digital collection of board games.
```

#### Acceptance Criteria
- [ ] There is a link to 'Sign In' on the homepage.
- [ ] If I fill in my email and password correctly, I am greeted and redirected to my board game collection.
- [ ] If I input my password incorrectly, I am given an error message.
- [ ] If I am signed in, I should not see a link to 'Sign Up'.


## User Stories (Non-core)

### View the Details of a Board Game
```no-highlight
As a visitor of the Game Collector website
I want to see the details of a board game
So that I can find out what I want to purchase next.
```

#### Acceptance Criteria
- [ ] From the board games index page, I should be able to click on a link for a board game.
- [ ] I should see the name, publisher, description, and release date of the board game.

### Add a Board Game to My Collection
```no-highlight
As a Board Game Collector
I want to add a board game to my collection
So that I can bask in the glory of my collection.
```

#### Acceptance Criteria
- [ ] From the show page for a board game, if a game isn't in my collection, I should see a button to 'add to collection'.
- [ ] When I add a game to my collection, I should receive a message saying that the board game was added.
- [ ] From the homepage, I should see a link to 'My Collection' which shows me all the board games in my collection.
- [ ] If the game is in my collection, I should see a message on the board game show page that says: 'collected'.


### Admin Views a List of Users
```no-highlight
As an administrator of the Game Collector Website
I want to see a list of users and email addresses
So that I can view who is using my website.
```

#### Acceptance Criteria
- [ ] I can see a link to view a list of users from the homepage
- [ ] The page should contain the user's full name, email address, role, and the number of board games in their collection.
- [ ] If I am not an administrator, I should be redirected to the homepage.
