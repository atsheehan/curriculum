##OMG We have all the ingredients but they're in a `CSV` file!!!

###Instructions
Ok, we have all the ingredients for our *amazing* Roasted Brussels Sprouts recipe, but they're in a `CSV` file! Oh no! We're going to be keeping a database of Brussels Sprout recipes, so a `CSV` is just going to be too unwieldy to deal with once we start adding more recipes and ingredients. Luckily, our friend the PostgreSQL [elephant](http://postgresapp.com/) has come to our rescue and informed us that we can store whatever we need in a PostgreSQL database and use Ruby to query it. Sounds conventient right? So let's do that! Your job is to do the following:

* Create a PostgreSQL database called `ingredients`
* Grab all the data in the `CSV` file and store it in `ingredients` using Ruby's `pg` gem.
* Print out the ingredients for our Roasted Brussel Sprouts recipe onto the screen using Ruby numbered from 1 through 4.

###Learning Goals
* Connect to a PostgreSQL database from Ruby using the `pg` gem.
* Push `CSV` data into a PostgreSQL database.
* Print out PostgreSQL data from your database to the screen using Ruby.

###Output

Running `code.rb` should produce the following output:

```
1. 1 1/2 pounds Brussels sprouts
2. 3 tablespoons good olive oil
3. 3/4 teaspoon kosher salt
4. 1/2 teaspoon freshly ground black pepper
```
###Tips
* Install the PostgreSQL gem by running `gem install pg` from your command line.
* Pay attention to the data structures that are returned by different methods.
