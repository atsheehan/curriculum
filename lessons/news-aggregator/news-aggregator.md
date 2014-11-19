It's important to stay connected with what's going on in the world (even if that means spending hours scouring reddit rather than accomplishing anything productive). Let's build a news aggregator so we can share some pointless articles and help others waste time effectively.

### Learning Objectives

* Build an application that receives user input via HTTP POST requests.
* Persist user data on the server so it can be used to generate pages dynamically.

### Instructions

Build a web application using Sinatra that displays a list of articles that users have submitted. The application should satisfy the following user stories:

```no-highlight
As a slacker
I want to be able to submit an incredibly interesting article
So that other slackers may benefit
```

Acceptance Criteria:

* When I visit `/articles/new` it has a form to submit a new article.
* The form accepts an article title, URL, and description.
* When I successfully post an article, it should be saved to a CSV file.

```no-highlight
As a slacker
I want to be able to visit a page that shows me all the submitted articles
So that I can slack off
```

Acceptance Criteria:

* When I visit `/articles` I should be able to see all the articles that have been submitted.
* Each article should show the description, title, and URL.
* If I click on the URL it should take me to the relevant page inside of a new tab.

For an extra **optional** challenge, implement the following additional user stores:

```no-highlight
As an errant slacker
I want to receive an error message
When I submit an invalid article
```

Acceptance Criteria:

* If I do not specify a title, URL, and description, I receive an error message, and the submission form is re-rendered with the details I have previously submitted.
* If I specify an invalid URL, I receive an error message, and the submission form is re-rendered with the details I have previously submitted.
* If I specify a description that doesn't have 20 or more characters, I receive an error message, and the submission form is re-rendered with the details I have previously submitted.
* The submitted article is not saved in any of the above cases.

```no-highlight
As a plagarizing slacker
I want to receive an error message
When I submit an article that has already been submitted
```

Acceptance Criteria:

* If I specify a URL that has already been submitted, I receive an error message, and the submission form is re-rendered with the details I have previously submitted.
* The submitted article is not saved in the above case.
