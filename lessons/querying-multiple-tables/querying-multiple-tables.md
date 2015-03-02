### Learning Goals

* Understand what primary keys and foreign keys are
* Query values from multiple tables using `JOIN`
* Filter on values found in different tables
* Understand how an `INNER JOIN` differs from an `OUTER JOIN`

### Goin' Back to the Movies

In a previous assignment we discussed some basic querying and filtering techniques to retrieve rows from a table in the database. The queries in that assignment were limited to pulling rows from a single table at a time.

If we restricted our queries to a single table we lose a lot of the flexibility that SQL provides. Going back to the `movies` database, what if we wanted to find all movies from a specific genre? We have both a `movies` table and a `genres` table but we need some way to combine this information into a single query. This is where the `JOIN` operation comes into play.

### Understanding Relational Data

Before we talk about how to use a `JOIN` we need to figure out how rows from two separate tables are related. If we take a look at the structure of the `movies` table (using `\d movies`) we might notice that it contains a column named `genre_id`:

```no-highlight
   Column   |            Type             |                      Modifiers
------------+-----------------------------+-----------------------------------------------------
 id         | integer                     | not null default nextval('movies_id_seq'::regclass)
 title      | character varying(255)      | not null
 year       | integer                     | not null
 synopsis   | text                        |
 rating     | integer                     |
 created_at | timestamp without time zone |
 updated_at | timestamp without time zone |
 genre_id   | integer                     | not null
 studio_id  | integer                     |
Indexes:
    "movies_pkey" PRIMARY KEY, btree (id)
```

The `genre_id` column has a type `integer`. An integer doesn't really tell us much about the genre. Let's see what the actual value looks like on a row in the `movies` table:

```SQL
SELECT title, genre_id FROM movies WHERE title = 'The Big Lebowski';

      title       | genre_id
------------------+----------
 The Big Lebowski |        3
(1 row)
```

So the `genre_id` has a value of `3`. This still doesn't provide much information about the genre for this movie.

What the `genre_id` does provide is a reference to another location in the database that might have more information. Let's take a look at what the `genres` table looks like (using `\d genres`):

```no-highlight
   Column   |            Type             |                      Modifiers
------------+-----------------------------+-----------------------------------------------------
 id         | integer                     | not null default nextval('genres_id_seq'::regclass)
 name       | character varying(255)      | not null
 created_at | timestamp without time zone |
 updated_at | timestamp without time zone |
Indexes:
    "genres_pkey" PRIMARY KEY, btree (id)
```

Notice that our `genres` table not only contains a `name` column (e.g. Action, Drama, Horror, etc.) but also an `id` column. Let's see what a row from the `genres` table looks like:

```SQL
SELECT * FROM genres WHERE id = 3;

 id |  name  |         created_at         |         updated_at
----+--------+----------------------------+----------------------------
  3 | Comedy | 2013-11-22 23:23:58.546024 | 2013-11-22 23:23:58.546024
(1 row)
```

We can see that this row represents the Comedy genre but that it also has an identifier with a value of 3. This identifier can be used to uniquely target this row in the `genres` table and is referred to as a **primary key**. Whenever we need to reference a genre somewhere else in the database we can just use the `id` value rather than having to copy the string `'Comedy'` everywhere. Primary keys do not always need to be integers but they do need to be unique within a table. The convention for Rails applications is to assign an integer column named `id` to every table to act as the primary key.

Going back to the `movies` table, when we looked for the genre we came up with a `genre_id` set to the value of `3`. Then we we looked at the `genres` table we found that the Comedy genre had an `id = 3`. This is how we link a genre to a movie. The `genre_id` on `movies` is referred to as a **foreign key** to the `genres` table. If we were to compare the values from both tables side-by-side, it might look something like:

```no-highlight
   movies.title   | movies.genre_id | genres.id | genres.name
------------------+-----------------+-----------+-------------
 The Big Lebowski |        3        |     3     |   Comedy
```

### Joining Up

By combining some of the columns from `movies` and `genres` we can see that the foreign key `movies.genre_id` matches up with the primary key `genres.id`.

This is essentially what a `JOIN` operation in SQL does for us. We could duplicate the results above with the following SQL statement:

```SQL
SELECT movies.title, movies.genre_id, genres.id, genres.name
FROM movies JOIN genres ON movies.genre_id = genres.id
WHERE movies.title = 'The Big Lebowski';

      title       | genre_id | id |  name
------------------+----------+----+--------
 The Big Lebowski |        3 |  3 | Comedy
(1 row)
```

After we specify that we want to query rows from the `movies` table with `FROM movies`, we then state that we want to include the columns from the `genres` table with the `JOIN genres ON movies.genre_id = genres.id` clause. Notice how in the `ON movies.genre_id = genres.id` we're defining our foreign key / primary key relationship between the two tables. When the two tables are joined together it is this relationship that dictates what values to populate for each column. Let's re-run this query for a few more rows:

```SQL
SELECT movies.title, movies.genre_id, genres.id, genres.name
FROM movies JOIN genres ON movies.genre_id = genres.id LIMIT 10;

               title                | genre_id | id |        name
------------------------------------+----------+----+--------------------
 Troll 2                            |        2 |  2 | Horror
 The Royal Tenenbaums               |        3 |  3 | Comedy
 The Life Aquatic with Steve Zissou |        5 |  5 | Drama
 Rushmore                           |        3 |  3 | Comedy
 Bottle Rocket                      |        5 |  5 | Drama
 The Darjeeling Limited             |        6 |  6 | Action & Adventure
 Little Miss Sunshine               |        3 |  3 | Comedy
 Fantastic Mr. Fox                  |        6 |  6 | Action & Adventure
 The Graduate                       |        5 |  5 | Drama
 Ghost World                        |        5 |  5 | Drama
(10 rows)
```

For each row from the `movies` table the values from the `genres` table are chosen based on the `movies.genre_id = genres.id` relationship. Every row will have identical values for `movies.genre_id` and `genres.id`. In fact, we don't really care about the `id` values in our results, we just want to include the name of the genre. We could simplify our query a bit by excluding the identifiers in the output:

```SQL
SELECT movies.title, genres.name
FROM movies JOIN genres ON movies.genre_id = genres.id LIMIT 10;

               title                |        name
------------------------------------+--------------------
 Troll 2                            | Horror
 The Royal Tenenbaums               | Comedy
 The Life Aquatic with Steve Zissou | Drama
 Rushmore                           | Comedy
 Bottle Rocket                      | Drama
 The Darjeeling Limited             | Action & Adventure
 Little Miss Sunshine               | Comedy
 Fantastic Mr. Fox                  | Action & Adventure
 The Graduate                       | Drama
 Ghost World                        | Drama
(10 rows)
```

Here we're still using the relationship between the `movies.genre_id` and `genres.id` but we're not including those values in the output. Another improvement we can make is to give better names to the columns being returned:

```SQL
SELECT movies.title AS movie, genres.name AS genre
FROM movies JOIN genres ON movies.genre_id = genres.id LIMIT 10;

               movie                |       genre
------------------------------------+--------------------
 Troll 2                            | Horror
 The Royal Tenenbaums               | Comedy
 The Life Aquatic with Steve Zissou | Drama
 Rushmore                           | Comedy
 Bottle Rocket                      | Drama
 The Darjeeling Limited             | Action & Adventure
 Little Miss Sunshine               | Comedy
 Fantastic Mr. Fox                  | Action & Adventure
 The Graduate                       | Drama
 Ghost World                        | Drama
(10 rows)
```

Now we're relabeling the `title` and `name` columns to `movie` and `genre` using the `original_column AS alias` operator. When dealing with columns from multiple tables the names can sometimes become ambiguous so it can be helpful to assign more meaningful names as we did here.

### Filtering on JOIN tables

Now that we've joined two tables together we can use the columns from either table to filter some of our rows. For example, if we wanted to only show Horror movies we can filter our results by a value on the `genres` table:

```SQL
SELECT movies.title, genres.name
FROM movies JOIN genres ON movies.genre_id = genres.id
WHERE genres.name = 'Horror' LIMIT 10;

              title               |  name
----------------------------------+--------
 Troll 2                          | Horror
 Beetlejuice                      | Horror
 Zombieland                       | Horror
 ZMD: Zombies of Mass Destruction | Horror
 Sleepy Hollow                    | Horror
 The Addams Family                | Horror
 Gremlins                         | Horror
 Scary Movie                      | Horror
 Twilight                         | Horror
 Final Destination 2              | Horror
(10 rows)
```

Whenever we are working with multiple tables via a `JOIN` we can access columns on either table using the format `table_name.column_name`. Here we are using `genres.name` in our `WHERE` clause to only include movies that have a genre named `'Horror'`.

#### Joining More Than Two Tables

We're not limited to joining on just two tables. Consider the following query where we include both the genre and studio with the name of the movie:

```SQL
SELECT movies.title AS movie, genres.name AS genre, studios.name AS studio
FROM movies
  JOIN genres ON movies.genre_id = genres.id
  JOIN studios ON movies.studio_id = studios.id
LIMIT 10;

               movie                |       genre        |              studio
------------------------------------+--------------------+----------------------------------
 Troll 2                            | Horror             | MGM
 The Royal Tenenbaums               | Comedy             | Buena Vista Distribution Compa
 The Life Aquatic with Steve Zissou | Drama              | Buena Vista
 Rushmore                           | Comedy             | Touchstone Pictures
 Bottle Rocket                      | Drama              | Columbia Pictures
 The Darjeeling Limited             | Action & Adventure | Fox Searchlight Pictures
 Little Miss Sunshine               | Comedy             | Fox Searchlight
 Fantastic Mr. Fox                  | Action & Adventure | 20th Century Fox
 The Graduate                       | Drama              | Embassy Pictures/Rialto Pictures
 Ghost World                        | Drama              | United Artists
(10 rows)
```

Here, we're querying from three tables by using two `JOIN` operations. We could continue joining as many tables as needed to get the results we want. Remember that we need to use the fully qualified names of the columns to differentiate between columns in multiple tables (e.g. `genres.name` and `studios.name`).

### NULL Foreign Keys

If we look at the structure of our `movies` table again (`\d movies`) we might notice that we have another row that looks like a foreign key:

```no-highlight
   Column   |            Type             |                      Modifiers
------------+-----------------------------+-----------------------------------------------------
 id         | integer                     | not null default nextval('movies_id_seq'::regclass)
 title      | character varying(255)      | not null
 year       | integer                     | not null
 synopsis   | text                        |
 rating     | integer                     |
 created_at | timestamp without time zone |
 updated_at | timestamp without time zone |
 genre_id   | integer                     | not null
 studio_id  | integer                     |
Indexes:
    "movies_pkey" PRIMARY KEY, btree (id)
```

In addition to `genre_id`, we also have the `studio_id`. Notice that under the `Modifiers` column that `genre_id` has the `not null` constraint: every row _must_ contain a reference to a genre (i.e. it cannot contain `NULL`). But for `studio_id` we don't have such a constraint. This means that we could have a movie that does not have an associated studio. We can check to see if this is the case with a query checking for `NULL` on the `studio_id` column:

```SQL
SELECT title, studio_id FROM movies WHERE studio_id IS NULL;
```

This query should return almost 300 movies. One thing to note about this query is that when checking to see if a column is `NULL` we can't use `column_name = NULL`. Instead we have to use the `IS` operator: `studio_id IS NULL` or `studio_id IS NOT NULL`. `NULL` has a few interesting semantics when used in conditionals and the `IS` operator will ensure that we get our expected results.

To see another example, let's try querying for all of the Rocky movies:

```SQL
SELECT title, studio_id FROM movies WHERE title LIKE 'Rocky%';

    title     | studio_id
--------------+-----------
 Rocky        |        12
 Rocky Balboa |         2
 Rocky II     |        12
 Rocky IV     |       120
 Rocky III    |         2
 Rocky V      |
(6 rows)
```

We have six Rocky movies and all of them except for the fifth installment have a studio associated with them. Let's get the actual names of the studios by joining our `movies` table with the `studios` table:

```SQL
SELECT movies.title, movies.studio_id, studios.id, studios.name
FROM movies JOIN studios ON movies.studio_id = studios.id
WHERE movies.title LIKE 'Rocky%';

    title     | studio_id | id  |        name
--------------+-----------+-----+---------------------
 Rocky        |        12 |  12 | United Artists
 Rocky Balboa |         2 |   2 | MGM
 Rocky II     |        12 |  12 | United Artists
 Rocky IV     |       120 | 120 | Metro-Goldwyn-Mayer
 Rocky III    |         2 |   2 | MGM
(5 rows)
```

We now have our studio names, but what happened to Rocky V? Remember that Rocky V did not have a `studio_id` (it contained a `NULL` value). So when we included our `JOIN` command it tried to match up each row in the `movies` table with the corresponding row in the `studios` table by matching the foreign key `movies.studio_id` to the primary key `studios.id`. If we wanted to include Rocky V, we have no foreign key to match up:

```no-highlight
 movies.title | movies.studio_id | studios.id |   studios.name
--------------+------------------+------------+---------------------
 Rocky        |               12 |         12 | United Artists
 Rocky Balboa |                2 |          2 | MGM
 Rocky II     |               12 |         12 | United Artists
 Rocky IV     |              120 |        120 | Metro-Goldwyn-Mayer
 Rocky III    |                2 |          2 | MGM
 Rocky V      |             NULL |        ??? | ???
```

In this case, Rocky V was kicked out of the result set because it did not belong to a studio. This behavior is known as an `INNER JOIN` and is the default when we don't specify otherwise.

If we did want to include Rocky V, we need to specify that we want to include _all_ rows in the table on the left regardless of whether they have a match or not (the left and right table refers to the order in which we join them: in `FROM movies JOIN studios`, the left table will be `movies` and the right table `studios`). We can change the behavior of `JOIN` by using a `LEFT OUTER JOIN`:

```SQL
SELECT movies.title, movies.studio_id, studios.id, studios.name
FROM movies LEFT OUTER JOIN studios ON movies.studio_id = studios.id
WHERE movies.title LIKE 'Rocky%';

    title     | studio_id | id  |        name
--------------+-----------+-----+---------------------
 Rocky        |        12 |  12 | United Artists
 Rocky Balboa |         2 |   2 | MGM
 Rocky II     |        12 |  12 | United Artists
 Rocky IV     |       120 | 120 | Metro-Goldwyn-Mayer
 Rocky III    |         2 |   2 | MGM
 Rocky V      |           |     |
(6 rows)
```

Now, we include Rocky V even though it doesn't have a studio value. The `LEFT OUTER JOIN` indicates that we should include all of the rows from `movies` regardless of whether they have a matching studio (although the `WHERE movies.title LIKE 'Rocky%'` conditional still applies).

### Rules to Follow

#### Always Include A Primary Key

When referencing other tables, it is important to have a primary key available. You can join on any column but the primary key should be a column or combination of columns that uniquely identifies a row. Consider the storing a list of people by first name and last name:

```no-highlight
 first_name | last_name
------------+------------
 Bob        | Loblaw
 Barry      | Zuckerkorn
 Gene       | Parmesan
```

Now imagine a scenario where another person named Bob Loblaw was stored in the table:

```no-highlight
 first_name | last_name
------------+------------
 Bob        | Loblaw
 Barry      | Zuckerkorn
 Gene       | Parmesan
 Bob        | Loblaw
```

How would we differentiate the first Bob from the second one? They are two separate people but we don't have a unique identifier. If we included a unique `id` attribute to act as the primary key we wouldn't run into this problem:

```no-highlight
 id | first_name | last_name
----+------------+------------
  1 | Bob        | Loblaw
  2 | Barry      | Zuckerkorn
  3 | Gene       | Parmesan
  4 | Bob        | Loblaw
```

Now we have the `id` column that we can join on which ensures that we'll retrieve the right Bob. Bob with an `id = 1` is a different person from Bob with an `id = 4`.

### INNER JOIN or OUTER JOIN?

The only time we'll need to consider whether to use an `INNER JOIN` or `OUTER JOIN` is when the foreign key may contain `NULL` values. Always default to an `INNER JOIN` (or just `JOIN`) unless we know that there may be `NULL` values.

### Use Fully Qualified Column Names

Although not always required, use the fully qualified column names. A fully qualified name will include both the name of the table and the name of the column (e.g. `movies.title` rather than just `title`). This helps avoid issues that arise when joining on multiple tables that have the same column name:

```SQL
SELECT title, name FROM movies
  JOIN genres ON movies.genre_id = genres.id
  JOIN studios ON movies.studio_id = studios.id;

ERROR:  column reference "name" is ambiguous
```

In the above statement we're joining both the `genres` table and the `studios` table to the `movies` table. Both `genres` and `studios` have the `name` column so when we include `SELECT title, name` the database engine does not known which table we want to reference. Instead we could write our query as:

```SQL
SELECT movies.title, genres.name, studios.name FROM movies
  JOIN genres ON movies.genre_id = genres.id
  JOIN studios ON movies.studio_id = studios.id;
```

### Resources

* [Visual Explanation of A SQL JOIN][coding_horror_joins]

### Why This Is Important

Querying from multiple tables is often necessary to retrieve the information we want. By aggregating information from multiple sources we can build more complex queries that can give us interesting insights into our data.

[coding_horror_joins]: http://www.codinghorror.com/blog/2007/10/a-visual-explanation-of-sql-joins.html
