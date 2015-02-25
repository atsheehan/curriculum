### Instructions

Update your [grocery list app](/lessons/grocery-list)
to read and write information to a PostgreSQL database instead of a CSV. Also,
use Javascript to create an alert box if someone tries to submit a blank entry
via your form.

### Requirements

* Visiting `GET /groceries` should display a list of groceries read from the database, as well as a form for adding a new grocery item.
* The form to add a new grocery item requires that the name be specified.
  * If the name is left blank and the form is submitted, an alert box should appear using Javascript warning the user of the error.
* The form submits to `POST /groceries` which saves the new item to the database.

### Setting up the database

Create a database called `grocery_list`. Once your database is created, use the
`schema.sql` file to create your table. Remember, you can execute your SQL statements
in the database using the following command:
```
$ psql grocery_list < schema.sql
```

### Learning Goals

* Reading and writing information to a database
* Using Javascript create alert boxes in response to events

### Tips

Feel free to copy over code from your last Grocery List app!
