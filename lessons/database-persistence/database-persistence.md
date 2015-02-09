The ability to insert and retrieve new information is a basic requirement of most web applications. In this article we'll look at why many applications rely on **relational databases** to manage storing and querying information and how we can integrate them into our application.

### Learning Goals

* Understand why relational databases are used.
* Connect to a database using the `psql` command.
* Create a table within the database.
* Query the database using a SQL statement.
* Insert information using a SQL statement.
* Run SQL statements in Ruby using the `pg` gem.
* Sanitize user input to prevent SQL injection attacks.

### Storing Information

Most applications have a requirement to store information in one form or another for some future use. We can utilize Ruby's Array and Hash data structures to store information in memory except when the program terminates does our data.

We dealt with this issue in the [HTTP POST and HTML Forms article](/lessons/http-post-and-html-forms) by writing to the file system. Files exist outside of our Ruby process so that when the application restarts we still have access to the tasks that have been saved to the file.

Writing to a file solves the persistence issue but what happens as our data becomes more complex? What if we want to add users to our app and support comments on our tasks? We could define a new format for our file to support this extra data but it will become unwieldy quickly.

Another common problem is concurrency. We often have more than one web server running our application at a time. If two different Ruby processes try writing to the same file simultaneously we'll most likely end up corrupting our data. We could implement some sort of file-locking mechanism to prevent this but our code will become very complex.

### Relational Databases

An alternative is to avoid writing to files directly and delegate that responsibility to another application. These types of applications are known as database management systems, and in this article we'll focus on **relational database management systems (RDBMS)** since they are widely used for web applications.

A relational database management system is an application that provides an interface for storing and querying information while hiding the details of reading and writing to files from the end user. This gives the RDBMS the flexibility to store information in a compact and efficient manner for querying as well as handle issues such as concurrent writes without corrupting any data.

**PostgreSQL** is a free and open-source relational database management system. It contains the software that manages how our information is stored and returned to us when we query it. **SQL** is the language that we can use to interface with a relational database. We use SQL statements to specify how we want to query, create, modify, or delete information.

This distinction is important: whereas SQL is a _language_ that we use for working with our data, PostgreSQL is the actual software that can interpret our SQL statements and store/retrieve data. Similarly, Ruby is a programming _language_ that we write but it is the Ruby _interpreter_ that turns our source files into running code. PostgreSQL is acting as the _interpreter_ for the SQL statements we write and persisting and retrieving our data.

There are other relational databases besides PostgreSQL such as MySQL, Oracle, and Microsoft SQL Server. All of these databases provide similar interfaces to the end user but the inner workings are different. We chose to use PostgreSQL since it is extremely stable, performant, and also free and open-source.

### Installing PostgreSQL

To follow along in this article you'll need to install a PostgreSQL server on your development machine. There are a number of ways to install PostgreSQL but the simplest way is to use [Postgres.app](http://postgresapp.com/). Download the application and follow the installation instructions on the website. An icon should appear in the task bar to indicate the server is up and running.

To verify everything was setup correctly, try running the `createdb` command in the terminal:

```no-highlight
$ createdb todo
```

If this commands runs without any output or you receive an `ERROR: database already exists` warning, then the database server is running.

At this point we should have our PostgreSQL server running in the background and the _todo_ database created. We can try connecting to our database with the following command:

```no-highlight
$ psql todo

psql (9.3.5)
Type "help" for help.

todo=#
```

The `psql` program is an interactive command-line client to the PostgreSQL database. The command `psql todo` will connect to the `todo` database and place you in an interactive shell that you can use to query the database (similar to how `irb` will place you in an interactive shell for running Ruby statements).

Once we've verified that we can connect to the database we can exit out of the `psql` client by typing `\q` or pressing `Ctrl` + `D`:

```no-highlight
todo=# \q
$
```

### Database Schema

An RDBMS can support multiple databases on a single server. A **database** is how we can logically group information at the application level: it is typical to have a single database for each application that we write. We already created the `todo` database that we can use with the [TODO list application][todo-sample-code] created in the [HTTP POST and HTML Forms lesson][http-post-article].

Unlike writing to a file, relational databases require that we define the _structure_ of our information before we can store it. This structure enables PostgreSQL to efficiently organize and query the information with minimal amounts of wasted space. How we structure our information is often referred to as our **database schema**.

Part of our schema is defined by the **tables** we've created. A table is used to store one kind of information. For our TODO app we'll probably just have a _tasks_ table, but if we added users and comments we would have separate tables to represent those entities as well.

A table is similar to a spreadsheet in that it has **rows** and **columns**. Each row represents an individual record in that table. For the _tasks_ table each row would represent a single task.

Each table has a fixed number of columns defined by the schema and each row in that table has a value for each column. Unlike most spreadsheets, each column in a table has an associated **data type** (e.g. strings, integers, dates, etc.). These data types enforce certain constraints on the information we supply as well as making it easier and more flexible to query in the future.

Let's re-connect to the `todo` database and create a table to store our tasks:

```no-highlight
$ psql todo

psql (9.3.5)
Type "help" for help.

todo=#
```

We can use the `\d` command to list all of the tables that currently exist:

```no-highlight
todo=# \d
No relations found.
```

Here we can see that we don't have any tables defined in this database (_relation_ is a fancy word for table). To create our _tasks_ table we can use the `CREATE TABLE` command and specify the columns we want:

```no-highlight
todo=# CREATE TABLE tasks (name varchar(100));
```

Here we're saying that we want to create a table named _tasks_ that has a single column _name_ that stores values of the type _varchar(100)_. The data type _varchar(100)_ is often used in relational databases to represent strings up to 100 characters in length.

If we look at the list of tables defined we should see our newly created one show up:

```no-highlight
todo=# \d
         List of relations
 Schema | Name  | Type  |  Owner
--------+-------+-------+----------
 public | tasks | table | asheehan
(1 row)
```

If we want to find more information about our _tasks_ table, we can re-use the `\d` command while supplying the table name:

```no-highlight
todo=# \d tasks
            Table "public.tasks"
 Column |          Type          | Modifiers
--------+------------------------+-----------
 name   | character varying(100) |
```

Great, we have a table! Now what can we do with it?

### Querying and Inserting Records

If we want to see what is in our _tasks_ table we can write a SQL query to retrieve this information for us:

```SQL
todo=# SELECT name FROM tasks;
 name
------
(0 rows)
```

The **SELECT** statement will return the selected columns from the table specified in the **FROM** clause. Since we just created this table we get back an empty result set.

We can write a SQL statement to add new rows to the table:

```SQL
todo=# INSERT INTO tasks (name) VALUES ('learn SQL');
INSERT 0 1
```

The **INSERT** statement will add new records to the specified table with the given values for each column. The `INSERT 0 1` return value indicates that one row was just inserted (the zero indicates an ID value that we aren't using at this point).

To verify that the record was successfully added, we can re-run our previous query:

```SQL
todo=# SELECT name FROM tasks;
   name
-----------
 learn SQL
(1 row)
```

We should get back the row that we just inserted.

### SQL and Ruby

We've seen the basics of how to use SQL to communicate with a PostgreSQL database using the `psql` tool, but how do we incorporate that into our Ruby applications?

Before we can issue a SQL command we need to open a connection to the database server. The `pg` gem is a Ruby library that enables us to communicate with a PostgreSQL server. To install this gem, run the following command:

```no-highlight
$ gem install pg
```

Now we can try querying the database in an IRB session:

```no-highlight
> require "pg"
 => true

> connection = PG.connect(dbname: "todo")
 => #<PG::Connection>

> results = connection.exec("SELECT name FROM tasks")
 => #<PG::Result>

> results.to_a
=> [{"name"=>"learn SQL"}]

> connection.close
 => nil
```

First we have to load the library in memory using the `require "pg"` statement. The `PG.connect` method will open a connection to the server which we can then use to send SQL statements. When we call the `exec` method on the connection, we pass in the SQL statement we want to execute and we're returned the results from the server. The results are returned as a `PG::Result` object but it behaves very similarly to an array of hashes, which we can see by calling the `to_a` method. Whenever we're finished with a connection we'll want to close it (using the `close` method).

Since we'll be using our database connection frequently, let's define our own method that handles automatically opening and closing a connection to the `todo` database:

```ruby
require "pg"

def db_connection
  begin
    connection = PG.connect(dbname: "todo")
    yield(connection)
  ensure
    connection.close
  end
end
```

The `PG.connect` and `connection.close` statements are typical method calls, but what do the `yield(connection)` and `begin..ensure` statements do?

The `yield(connection)` statement allows this method to accept a block of code (in the form of a `do..end` or `{..}` block) that can be run in the middle of the method. If we wanted to use this method to query for a list of tasks, we might write something like:

```ruby
db_connection do |conn|
  conn.exec("SELECT name FROM tasks")
end
```

Notice how the `do..end` block accepts a single parameter: the `conn` parameter is assigned the value passed into `yield(connection)`. Within this block we can use the connection to query the database (by calling the `exec` method).

Once this block of code is finished, execution picks up right after the `yield` statement. We wrap up the method with an `ensure..end` block that closes out the connection. The reason we use `ensure` is that this code is guaranteed to run: even if an exception is thrown or something else goes wrong, the `ensure` block will guarantee that the code for closing the connection will get run.

### User Input

The SQL statement we used to query all of the tasks uses a fixed format: we just ask for the name of all rows in the _tasks_ table. In other cases our SQL will contain parameters that will vary based on user input. Consider a statement to insert a new task based on user input:

```SQL
INSERT INTO tasks (name) VALUES ('buy milk');
```

If a user typed _buy milk_ into an HTML form and submitted it, we could generate the SQL statement using string interpolation in Ruby:

```ruby
# params["task_name"] => "buy milk"
sql = "INSERT INTO tasks (name) VALUES ('#{params["task_name"]}')"
# => "INSERT INTO tasks (name) VALUES ('buy milk')"

db_connection do |conn|
  conn.exec(sql)
end
```

This might work for most use cases, but what happens when the user types in _initiate coup d'etat_:

```ruby
# params["task_name"] => "initiate coup d'etat"
sql = "INSERT INTO tasks (name) VALUES ('#{params["task_name"]}')"
# => "INSERT INTO tasks (name) VALUES ('initiate coup d'etat')"
# The extra quote breaks this SQL statement -----------^

db_connection do |conn|
  conn.exec(sql)
end
```

When we try to run this SQL statement our database will complain about an invalid SQL statement. The single quote within _initiate coup d'etat_ closes the string too early and breaks the statement.

At best our database refuses to run the statement because it is invalid SQL. At worst an attacker can exploit this vulnerability to insert specially crafted SQL fragments to run malicious code in our database. What would our SQL look like if the user input `a'); DROP TABLE tasks; --` (`--` starts a comment in SQL). This attack is known as [SQL Injection](http://en.wikipedia.org/wiki/SQL_injection) and is [very common on the web](http://xkcd.com/327/).

To prevent this we want to **sanitize** any input that we accept from users and **escape** special characters like `'` so they don't interfere with the structure of our SQL. We can use *placeholders* within a query and then provide values for those placeholders that get filtered for any malicious characters before they are inserted into the statement. The `exec_params` method will perform this filtering for us:

```ruby
db_connection do |conn|
  conn.exec_params("INSERT INTO tasks (name) VALUES ($1)", [params["task_name"]])
end
```

The placeholder in this case is the `$1` symbol that gets replaced by the first argument in the params array. If the user input contains any special characters (e.g. the `'` quote) then `exec_params` method will properly enclose those values so that it does not break the SQL statement.

### PostgreSQL-backed TODO Application

Let's return to the TODO application that was built in the [HTTP POST and HTML Forms article][http-post-article] and use PostgreSQL to store the list of tasks (sample code can be found [here][todo-sample-code]).

Within the _server.rb_ file there are two places where we're either reading tasks from or writing tasks to a file:

```ruby
get "/tasks" do
  # Reading from a file here...
  tasks = File.readlines("tasks.txt")
  erb :index, locals: { tasks: tasks }
end

post "/tasks" do
  task = params["task_name"]

  # Writing to a file here...
  File.open("tasks.txt", "a") do |file|
    file.puts(task)
  end

  redirect "/tasks"
end
```

We need to modify these two routes to read from and write to the _todo_ database instead of the _tasks.txt_ file. We'll first need to include the **pg** gem and also define our helper method that will open and close the database connection for us:

```ruby
require "sinatra"
require "pg"

def db_connection
  begin
    connection = PG.connect(dbname: "todo")
    yield(connection)
  ensure
    connection.close
  end
end
```

Now in our `get "/tasks"` and `post "/tasks"` routes we can use our database connection in place of the file:

```ruby
get "/tasks" do
  # Retrieve the name of each task from the database
  tasks = db_connection { |conn| conn.exec("SELECT name FROM tasks") }
  erb :index, locals: { tasks: tasks }
end

post "/tasks" do
  task = params["task_name"]

  # Insert new task into the database
  db_connection do |conn|
    conn.exec_params("INSERT INTO tasks (name) VALUES ($1)", [task])
  end

  redirect "/tasks"
end
```

Now whenever a user submits a task, it will be saved to our _todo_ database. One difference with this code is that when we query for the list of tasks we actually get back an array of hashes instead of an array of strings:

```ruby
# Returns a PG::Result object which behaves like an array of hashes
tasks = db_connection { |conn| conn.exec("SELECT name FROM tasks") }
```

We can either extract the task names in the controller or we can update our _views/index.erb_ file to handle the new data type:

```HTML+ERB
<ul>
  <% tasks.each do |task| %>
    <li><a href="/tasks/<%= task["name"] %>"><%= task["name"] %></a></li>
  <% end %>
</ul>
```

Since `task` is not a string but a Hash-like object, we extract the name by referring to `task["name"]`.

### In Summary

**Relational database management systems (RDBMS)** are a fundamental component of many web (and other) applications. Understanding their use and how to store and retrieve data via SQL is an essential skill to becoming a full-stack web developer.

**PostgreSQL** is a free and open-source RDBMS that we interact with by writing **SQL statements**. Each application will have its own **database** containing a set of **tables** to store any information. Each table defines a series of **columns** that specify the name and type of information it stores. Each **row** in a table represents an individual record and must supply a value for every column.

To use an RDBMS in our Ruby applications we can utilize the **pg** gem. To issue a SQL statement we first have to open a **connection** to the database and then submit the statement to be executed. The results of a query are returned as an array of hashes.

If a SQL statement contains user input it should be **sanitized** before being sent to PostgreSQL. Unsanitized input can lead to **SQL injection** attacks that enable malicious users to run arbitrary statements against our database.

[http-post-article]: /lessons/http-post-and-html-forms
[todo-sample-code]: https://github.com/LaunchAcademy/curriculum/tree/master/lessons/http-post-and-html-forms/sample-code
