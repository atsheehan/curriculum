##OMG It's Taking Too Long to Find Our Brussels Sprouts!

###Instructions

We have gigantic database `ingredients` of millions of ingredient records. We want all the rows of ingredients that have Brussels Sprouts in them, but querying them is taking forever. Database indices to the rescue!

###Setup
First create your database called ingredients as follows (from the command line):

`createdb ingredients`

After you have created your `ingredients` table, run the following command from the terminal:

`psql ingredients`

We now need to create the table our exercise cares about. Run the following command while in PostgreSQL:

`create table ingredients (quantity integer, unit varchar(255), name varchar(255));`

Now you have an `ingredients` table in your `ingredients` database. After you have created your `ingredients` table, exit your psql terminal with `\q`. We provide you a `seeder.rb` file which you should run with the following command from the command line:

`ruby seeder.rb`

Let the seeder run for about 20 minutes (could be shorter or longer depending on your machine) until you have 10 million records in your ingredients database. You can check the number of rows you have from your psql terminal with `select count(*) from ingredients;`.

Write an SQL query to

* Find all rows that have an ingredient `name` of `Brussels sprouts`.
* Calculate the total count of rows of ingredients with a `name` of `Brussels sprouts`.
* Find all `Brussels sprouts` ingredients having a unit type of `gallon(s)`.
* Find all rows that have a unit type of `gallon(s)`, a name of `Brussels sprouts` or has the letter `j` in it.

Finally
* Implement a database index to speed up your above SQL queries.

###Learning Goals
* Utilize a database index to speed up SQL queries.
* Get more comfortable with the `psql` console.

###Output
* Submit a markdown file titled `submission.md` that has embedded screenshots depicting a 'before' and 'after' of your query (i.e., without and with an index). Include the SQL queries you wrote to search the database as well as to create the index.

###Tips
* Use the `SQL` query prefix `EXPLAIN ANALYZE` to calculate the total runtime of a query.
* Find more on how to write a markdown file [here](https://help.github.com/articles/markdown-basics/) and [here](https://help.github.com/articles/github-flavored-markdown/).
* Use the following syntax for embedding an image into a markdown file:

```
![alt](http://i.imgur.com/FCq35i5.png)
```
