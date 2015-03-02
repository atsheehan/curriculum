##OMG we need comments on our recipes!

Ok, we are going to need to figure out how to allow people comment on our recipes. Some recipes are going to be more popular than others and will probably get more comments. How are we going to do this?!

###Instructions
1. Create a PostgreSQL database titled `brussels_sprouts_recipes`.
2. Create two tables in this database. Call the first one `recipes` and the second one `comments`.
3. Determine the best column names for each of the above tables and create them.
4. Update `seeder.rb` to seed these above tables.
5. Associate the tables by implementing primary and foreign keys. Ask yourself questions about the relationships between the table to determine these relationships. For example, does a recipe have many comments? Does a comment have many recipes or just one recipe?
6. Write SQL code to answer the following questions.

  * How many recipes are there in total?
  * How many comments are there in total?
  * How would you find out how many comments each of the recipes have?
  * What is the name of the recipe that is associated with a specific comment?
  * Add a new recipe titled `Brussels Sprouts with Goat Cheese`. Add two comments to it.

###Learning Goals
* Understand database relations

###Tips
* Look into the [faker](https://github.com/stympy/faker) to generate arbitrary fake data to seed your database tables with.
