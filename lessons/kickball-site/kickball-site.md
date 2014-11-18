### Overview

In this mission, we will explore the most basic protocol and language of the web. The Hypertext Transfer Protocol (HTTP) and the Hypertext Markup Language (HTML) allow web developers across the world to communicate in complex and interesting ways.

#### Guiding Questions

* How does the world wide web work?

#### Learning Objectives

* Study the HTTP request and response model
* Manually issue a HTTP request and observe the response
* Generate dynamic HTML

#### Challenge

You have been commissioned by the premier League of Cool Kickball Professionals (LACKP) to build their first website. The league currently has 4 teams. We have supplied a CSV of the players.

Because this will be a multi-file program, you'll need to create a remote repository on GitHub to submit your response. (A simple Gist can't handle multiple files.) We'll cover working with remote repositories in more detail later in the course, but for now you can follow the instructions below:

* On your github.com home page, click the ```+``` dropdown menu in the top right corner. Select "New repository."
* Fill in the repository name and description. (Do not select the "Initialize this repository with a README" option.) Click "Create repository."
* When you have completed the challenge and have committed any final changes to your local repository, run the following commands:

```no-highlight
git remote add origin git@github.com:[YOUR_USER_NAME]/[YOUR_REPO_NAME].git
git push -u origin master
```
* If you make any subsequent changes, you can push them to your remote repository by running ```git push origin master``` (after committing your changes locally).

#### User Stories

```no-highlight
As a Kickball Fan
I want to view the professional teams
So that I can learn more about the players
```

Acceptance Criteria
* I can navigate to a distinct url and web page for each team
* Each team page displays the team's name
* Each team page displays each player's name along with their position

#### Noncore User Stories

```no-highlight
As a Kickball Fan
I want to see all players in a certain position
So that I can see who plays each position in the league
```

Acceptance Criteria
* I can navigate to a distinct url for each position
* Each position page displays the position
* Each position page lists each player in that position along with their team name
