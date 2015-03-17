Our brussels sprouts recipe blog needs a major makeover. We have many recipes and each of them can have many comments. We need to model this blog with ActiveRecord.

###Learning Goals
* Create a multi-table application
* Explore ways to associate tables
* Use a foreign key column

###Instructions
* Create a new Sinatra app with the [Sinatra ActiveRecord Starter Kit](https://github.com/LaunchAcademy/sinatra-activerecord-starter-kit). Follow the instructions in the reading about the basic setup.
* Create a `Recipe` model and associated migration. Determine the column names as you deem necessary. You don't have to worry about ingredients here.
* Create a `Comment` model and associated migration. Determine the column names as you deem necessary.
* Associate the two tables so that each recipe can have multiple comments posted about it.
* Load up your app in irb (see the reading for a description of how to do this) and follow these directions:
  * Create 5 recipes
  * Create 1-5 comments on all your recipes.
* Answer the following questions:
  * How would you return all the recipes in your database?
  * How would you return all the comments in your database?
  * How would you return the most recent recipe posted in your database?
  * How would you return all the comments of the most recent recipe in your database?
  * How would you return the most recent comment of all your comments?
  * How would you return the recipe associated with the most recent comment in your database?
  * How would you return all comments that include the string `brussels` in them?

####Output
Include a `README.md` file that contains the code for the queries above. Submit your code through `et`.
