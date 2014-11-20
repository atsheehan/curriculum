HTML and CSS are two core technologies used for presenting web pages to users. In this challenge you'll create a web page with a semantic HTML structure and corresponding CSS styles to re-create an existing website.

### Learning Objectives

* Use HTML to structure your data.
* Use CSS to style your pages.

### Instructions

The goal of this project is to recreate the front page of [Hacker News][hacker-news] using HTML and CSS. The page does not need to be functional but it should appear as shown in the screenshot below:

![Hacker News Home Page][home-page]

### Setup

We've provided a basic template for getting started. To start the web server, run the following command:

```no-highlight
$ ruby server.rb

== Sinatra/1.4.5 has taken the stage on 4567 for development with backup from Thin
>> Thin web server (v1.5.1 codename Straight Razor)
>> Maximum connections set to 1024
>> Listening on localhost:4567, CTRL+C to stop
```

This will serve a web page at [http://localhost:4567/index.html](http://localhost:4567/index.html) containing a single header with some lovely styling. Modify the `index.html` and `styles.css` files in the `public` directory so that they resemble the home page of Hacker News.

**Note:** Don't worry about making the comments page dynamic. You can reuse the same comments page for every post. The goal for this challenge is to practice working with HTML/CSS.
challenge.

When finished the home page should satisfy the following user story:

```no-highlight
As a slacking developer
I want to view a list of the latest tech articles
So that I can distract myself from doing actual work
```

Acceptance Criteria:
* Each article lists the title.
* Each article lists the domain of the link.
* Each article displays the points it has accumulated.
* Each article displays the user who submitted it.
* Each article displays the number of comments it has received.
* The list of articles must resemble the format of [Hacker News][hacker-news].

As an **optional** challenge, re-create the comments page so that it satisfies the following user story:

```no-highlight
As a slacking developer
I want to view comments on a tech article
So that I can troll other slackers
```

Acceptance Criteria:
* The title can be seen
* The domain of the link can be seen
* The user who submitted the link can be seen
* The number of comments can be seen
* Nested comments can be seen (up to three levels)
* There is a form where I can comment

### Tips

* Although you're copying the design of Hacker News, don't copy the HTML and CSS. The Hacker News markup uses a table-based layout whereas we would prefer to see more semantic markup.
* Right-clicking on a web page and selecting _Inspect Element_ in either Firefox or Chrome will allow you to see the relevant HTML and CSS affecting that section of the page.

[hacker-news]: https://news.ycombinator.com/
[sample-articles]: https://gist.github.com/atsheehan/8cfb57eabe68a5701664
[home-page]: https://s3.amazonaws.com/hal-assets.launchacademy.com/slacker-news/hacker-news-homepage.png
