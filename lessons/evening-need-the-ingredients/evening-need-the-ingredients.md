##OMG We don't know all the ingredients!

###Instructions
Our Brussels Sprouts recipe webpage only lists the first ingredient. This is a problem. How can we have sumptious Brussel Sprouts without knowing how to make them? Well, we are web developers, and hungry ones at that. We understand HTTP request-response and can use `telnet` to add the rest of the ingredients to the page. Your job is to do the following:

* Using `telnet`, issue a `POST` request to make sure all of the following ingredients are on the webpage:

```
1 1/2 pounds Brussels sprouts
3 tablespoons good olive oil
3/4 teaspoon kosher salt
1/2 teaspoon freshly ground black pepper
```

* Now, say you are the server and you are especially invested in making sure we have all the ingredients for our roasted brussel sprouts recipe (servers need to eat too). How does the server know what ingredient to add? Come prepared to discuss how the this occurs and what the `params` hash does to enable this.

###Learning Goals
* Utilize `telnet` to understand HTTP request-response.
* Understand the `params` hash that is part of web frameworks.

###Input
1. Make sure you have `sinatra` installed by running `gem install sinatra` from your terminal. Run `ruby server.rb` from your terminal to run the server on `localhost:4567`. Open your browser and go to `http://localhost:4567` to see the current status of the site.

###Output
After your `telnet` magic, the website should look the following:

![alt](http://i.imgur.com/FCq35i5.png)

* Provide a text file with an explanation of what steps you took to accomplish this task.

###Tips
* Run `bundle` from your terminal to have the right dependencies installed (like the `sinatra` gem, which is what your server is based on).
* You should not be modifying the view file or `ingredients.txt` directly at all. You're an elite hacker and should only be using `telnet` to solve this problem.
* You might want to put a `binding.pry` into your `POST` method to see what's going on, but other than that, you should not be making any changes to the file. Note: If you plan on doing this, make sure to run `gem install pry` from your console as well.
