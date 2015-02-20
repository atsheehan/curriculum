Reading and writing CSV files works for toy applications, but if we want our [News Aggregator](/lessons/news-aggregator) to take over the world we're going to need something a little more heavy-duty. Let's redesign our persistence layer so that we're reading from and writing to a PostgreSQL database rather than to files directly.

### Learning Objectives

* Define a database schema to store user-submitted articles.
* Read and write information to a PostgreSQL database from a Sinatra application.

### Instructions

There are two steps to converting from CSV files to PostgreSQL: defining the schema and modifying the web application.

#### Define the Schema

Before we can start writing to PostgreSQL we need to create a new database and define a schema. To create a new database named `news_aggregrator_development` run the following command:

```no-highlight
$ createdb news_aggregator_development
```

Now consider how you want to store the articles in your database. Within the *schema.sql* file, uncomment the `CREATE TABLE` SQL statement and add the appropriate column definitions for the *articles* table (`--` starts a comment in SQL). To execute these SQL statements against the database, run the following command:

```no-highlight
$ psql news_aggregator_development < schema.sql
```

#### Modify the Web Application

Expanding upon the web application built in the [News Aggregator](/lessons/news-aggregator) challenge, replace any calls that read or write to a CSV file with similar calls that communicate to the database created in the previous step. This should involve updating the `POST` request to write a new article to the database and the `GET` request to query for all articles.

### Tips

* Remember that all users are evil. Use the `exec_params` method with the `pg` gem to prevent users from running malicious SQL statements against the database.
* To enforce URL uniqueness in the database you may want to look at [unique indexes](http://www.postgresql.org/docs/9.4/static/indexes-unique.html) in PostgreSQL.
