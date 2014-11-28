### Learning Goals

* Generate a dynamic web page with information pulled from a database.
* Query for specific information based on the URL.

### Instructions

Build a web application using Sinatra to display a list of recipes stored in a PostgreSQL database.

A snapshot of the database is stored in the `recipes_database.sql` file. To prepare your database run the following commands:

```no-highlight
$ createdb recipes
$ psql recipes < recipes_database.sql
```

You should be able to connect to the `recipes` database after these commands have been run:

```no-highlight
$ psql recipes

psql (9.3.5)
Type "help" for help.

recipes=#
```

### Requirements

The web application should satisfy the following user stories:

```no-highlight
As a chef
I want to view a list of recipes
So that I may choose one that seems appetizing
```

Acceptance Criteria:

* Visiting `/recipes` lists the names of all of the recipes in the database, sorted alphabetically.
* Each name is a link that takes you to the recipe details page (e.g. `/recipes/1`)

```no-highlight
As a chef
I want to view the details for a single recipe
So that I can learn how to prepare it
```

Acceptance Criteria:

* Visiting `/recipes/:id` will show the details for a recipe with the given ID.
* The page must include the recipe name, description, and instructions.
* The page must list the ingredients required for the recipe.
