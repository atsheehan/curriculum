Once data is stored in a normalized format, relational databases excel at being able to query the information in a variety of ways. In this article we'll explore how we can use the SQL `SELECT` statement to take advantage of this.

### Learning Goals

* Query all rows and columns in a table
* Query specific columns in a table
* Filter the results shown using a `WHERE` clause
* Limit the number of rows returned using `LIMIT`
* Sort the results using `ORDER BY`

### Setup

For this article we'll be using a database containing information about movies. The setup is discussed in more detail in the [Database Relationships](/lessons/database-relationships) article but here's a quick recap of the commands. If you already have the `movies` database populated on your machine, skip the remaining steps in this section.

To download the database snapshot and save it to a temporary file, run the following commands:

```no-highlight
$ curl -o /tmp/movie_database.sql.gz https://s3.amazonaws.com/launchacademy-downloads/movie_database.sql.gz
$ gunzip /tmp/movie_database.sql.gz
```

This will save the database snapshot in `/tmp/movie_database.sql`. Then create the database with `createdb` and import the script using `psql`:

```no-highlight
$ createdb movies
$ psql movies < /tmp/movie_database.sql
```

After this command has finished, we can then open up a connection to the database to verify that we have some tables and data:

```no-highlight
$ psql movies

psql (9.3.1)
Type "help" for help.

movies=# SELECT count(*) FROM movies;
 count
-------
  3546
(1 row)
```

This is the PostgreSQL command prompt where we can write our SQL queries. If you ever need to exit out of the prompt, type `\q` or press `Ctrl` + `D`.

### Flexibility of SQL

One of the greatest strengths of a relational database is the flexibility we have when writing queries. If our database is designed in a sensible way, SQL allows us to combine and filter the information it contains in interesting ways depending on what we are trying to find. Try running the following query after connecting to the `movies` database:

```SQL
SELECT movies.title, movies.year, movies.rating FROM movies
  JOIN cast_members ON movies.id = cast_members.movie_id
  JOIN actors ON actors.id = cast_members.actor_id
WHERE actors.name = 'Tom Hanks'
ORDER BY movies.rating DESC;
```

This query will return all of the movies starring Tom Hanks sorted by critic rating:

```no-highlight
            title             | year | rating
------------------------------+------+--------
 Toy Story 2                  | 1999 |    100
 Toy Story                    | 1995 |    100
 Toy Story 3                  | 2010 |     99
 Big                          | 1988 |     97
 Catch Me If You Can          | 2002 |     96
--- more rows here
 Larry Crowne                 | 2011 |     35
 The Da Vinci Code            | 2006 |     25
(26 rows)
```

Given a list of movies and actors, PostgreSQL is able to aggregate and extract the information we are looking for through the use of a SQL statement. We'll discuss the various parts of this query over the next few sections.

### SELECT

For querying a database the statement you'll use most often is `SELECT`. One of the most basic queries we can write will query all of the rows from a given table:

```SQL
SELECT * FROM table_name;
```

The `FROM table_name` clause specifies the source of our information: we're interested in querying the data in `table_name`. By default this will mean every row found in that table although we'll discuss methods for filtering rows shortly.

The `SELECT *` portion specifies the columns to be displayed. In this case we use `*` which indicates that we want to display all of the columns.

Try running the following query in the `psql` prompt:

```SQL
SELECT * FROM actors;
```

The results should contain a list of actors and actresses, one per line, with an `id`, `name`, `created_at` and `updated_at` timestamps for each. Since there are quite a few rows in this table the results will be paged (you can tell if you're in a pager if there is a `:` or `(END)` on the bottom left of the terminal). Pressing the `Space` bar will display another pages worth of rows and pressing `q` will exit out of the results.

If we wanted to see a list of movies we could run the following query:

```SQL
SELECT * FROM movies;
```

This will display all of the rows and columns in the `movies` table. Unfortunately, the `movies` table includes the `synopsis` column which can contain quite a bit of text and clutters up the output. Instead, we can selectively include certain columns that we want returned in the results:

```SQL
SELECT title, year FROM movies;
```

This will still return all of the rows from the `movies` table but it will only include the movie title and year released in the results.

### WHERE

In many situations we're only interested in a subset of the data we have available. Rather than querying for _all_ of the movies in the database, maybe we only want to see those that came out in a specific year. To filter out rows from our results we can use the `WHERE` clause in our statements:

```SQL
SELECT columns FROM table_name WHERE conditional;
```

The `WHERE conditional` clause will filter out any rows that do not meet the given `conditional`. For example, if we only wanted to see movies released in 1977, we could write something like:

```SQL
SELECT title, year FROM movies WHERE year = 1977;
```

This should return something like the following:

```no-highlight
                  title                  | year
-----------------------------------------+------
 Annie Hall                              | 1977
 Close Encounters of the Third Kind      | 1977
 Eraserhead                              | 1977
 The Spy Who Loved Me                    | 1977
 I Spit on Your Grave (Day of the Woman) | 1977
 New York, New York                      | 1977
 The Many Adventures of Winnie the Pooh  | 1977
 Star Wars: Episode IV - A New Hope      | 1977
 Julia                                   | 1977
 The Man in the Iron Mask                | 1977
(10 rows)
```

When PostgreSQL is processing the SQL query, it first starts with all of the rows in the `movies` table (since we specified `FROM movies`). Then it applies the following conditional to each row: was this movie made in 1977 (`year = 1977`)? Only if this conditional is true is the row included in the final results. We can see that for the results shown above, every single row has the year set to 1977.

The possible conditionals are not just limited to testing equality. For numeric types we can compare values to see if they are greater than or less than some other value. If we wanted to find all movies with a critic's rating higher than 90, we could run:

```SQL
SELECT title, rating FROM movies WHERE rating > 90;
```

This checks the rating for every row in the `movies` table and only includes those that have a value greater than 90.

If we want to test multiple conditionals then we can chain them together using `AND` or `OR` (similar to `&&` and `||` in other programming languages). To retrieve movies from 1977 with a rating of 90 or higher we could write:

```SQL
SELECT title, rating FROM movies WHERE rating > 90 AND year = 1977;
```

Now for every row in the `movies` table PostgreSQL will check that it has a rating higher than 90 **and** that it was made in 1977 before returning it in the results.

The values do not always have to be numeric in a `WHERE` clause. We could test for string values using the equality operator `=`:

```no-highlight
SELECT title, year, rating FROM movies WHERE title = 'The Evil Dead';

     title     | year | rating
---------------+------+--------
 The Evil Dead | 1981 |     98
(1 row)
```

This returns any rows from the `movies` table that have a title matching `The Evil Dead`. Note that this tests for strings _exactly_ matching `The Evil Dead`. If we left out the `The` at the beginning we probably won't get what we want:

```SQL
SELECT title, year, rating FROM movies WHERE title = 'Evil Dead';

     title     | year | rating
---------------+------+--------
(0 rows)
```

When we want to match only a _portion_ of a string we can use the [`LIKE`](http://en.wikipedia.org/wiki/Where_(SQL)#LIKE) operator in SQL. `LIKE` is similar to the equality operator (`=`) except that it allows wildcard characters to be inserted:

```SQL
SELECT title, year, rating FROM movies WHERE title LIKE '%Evil Dead%';

     title     | year | rating
---------------+------+--------
 The Evil Dead | 1981 |     98
 Evil Dead 2   | 1987 |     98
(2 rows)
```

Now we're searching for any movies that have the term `Evil Dead` anywhere in the title. The `%` character in the `WHERE title LIKE '%Evil Dead%'` conditional is a wildcard that will match zero or more characters in a string. So `%Evil Dead%` will match any rows that have a title with zero or more characters followed by the word `Evil Dead`, then followed by zero or more characters.

There are a number of operators we can use in our conditional statements. Other useful operators include `ILIKE` for case-insensitive searches, [`IN`](http://en.wikipedia.org/wiki/Where_(SQL)#IN) for checking against multiple values, and [`BETWEEN`](http://en.wikipedia.org/wiki/Where_(SQL)#BETWEEN) for checking ranges of values.

### ORDER

The rows in a database are not necessarily stored in any order. When we run `SELECT * FROM movies` we're not guaranteed to receive the results sorted in any way. Sometimes this is acceptable but for other queries we might be interested in viewing the results sorted by some value. To achieve this we can use the `ORDER BY` clause in SQL.

Adding `ORDER BY` to a SQL statement will return the results sorted by the value we specify. If we wanted to sort the list of movies by the year they were released, we could run:

```no-highlight
SELECT title, year FROM movies ORDER BY year;

                            title                            | year
-------------------------------------------------------------+------
 Das Cabinet des Dr. Caligari. (The Cabinet of Dr. Caligari) | 1920
 Phantom Of The Opera                                        | 1925
 Wizard of Oz                                                | 1925
 Metropolis                                                  | 1927
 Un Chien Andalou (An Andalusian Dog)                        | 1928
 Le Million                                                  | 1931
 Frankenstein                                                | 1931
 Dracula                                                     | 1931
--- more rows here
```

The `ORDER BY year` clause will sort the rows based on the value in the `year` column. By default, the sort order will be ascending. The first row will be the smallest value and increase from there. We could also change the order to start with the highest value and descend from there using `DESC`.

```SQL
SELECT title, rating FROM movies ORDER BY rating DESC;
```

This will return rows starting with the highest rated movies since we used `ORDER BY rating DESC`.

### LIMIT

Usually when we use the `ORDER BY` query we're only interested in the first few results being returned. If we wanted to find the top ten highest rated movies we could run the following query and only use the first ten rows:

```SQL
SELECT title FROM movies ORDER BY rating DESC;
```

The problem with this query is that even though we only want the first ten, PostgreSQL will still return every row from the `movies` table. Considering there are over 3000 movies, this is an inefficient use of resources.

We can fix this issue by limiting the number of rows returned with the `LIMIT` clause:

```SQL
SELECT title FROM movies ORDER BY rating DESC LIMIT 10;
```

The `LIMIT 10` clause lets PostgreSQL know that it only needs to return the first ten rows it finds. Since we also specify the `ORDER BY rating DESC` clause we know that those first ten rows will have the highest ratings in the table.

### In Summary

To query for information within a database we often use the `SELECT` statement. We can specify where to find the information using the `FROM` clause and choose specific columns to return as well.

It is possible to filter rows using the `WHERE` statement. The type of filtering varies with the data type and we can also combine filters using the `AND` and `OR` keywords.

To ensure the rows return in sorted order we can specify an `ORDER BY` clause at the end and supply a column name. If we're only interested in a fixed number of rows we can use the `LIMIT` clause to specify the max number of rows to return.
