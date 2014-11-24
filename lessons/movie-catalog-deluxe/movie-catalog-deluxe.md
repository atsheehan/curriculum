### Learning Goals

* Render dynamic web pages with information pulled from a relational database.

### Instructions

Build a movie catalog backed by the `movies` database. The catalog should support the following routes:

* Visiting `/actors` will show a list of actors, sorted alphabetically by name. Each actor name is a link to the details page for that actor.
* Visiting `/actors/:id` will show the details for a given actor. This page should contain a list of movies that the actor has starred in and what their role was. Each movie should link to the details page for that movie.
* Visiting `/movies` will show a table of movies, sorted alphabetically by title. The table includes the movie title, the year it was released, the rating, the genre, and the studio that produced it. Each movie title is a link to the details page for that movie.
* Visiting `/movies/:id` will show the details for the movie. This page should contain information about the movie (including genre and studio) as well as a list of all of the actors and their roles. Each actor name is a link to the details page for that actor.

For an additional, **optional** challenge, implement the following features:

* Allow different orderings for the `/movies` page. The user should be able to sort by year released or rating by visiting `/movies?order=year` or `/movies?order=rating`.
* Paginate the `/movies` and `/actors` page using the `LIMIT` and `OFFSET` clauses in PostgreSQL. Each page should show up to 20 entries at a time. Visiting `/movies?page=2` should show the next 20 movies.
* Add a search feature for `/movies`. Visiting `/movies?query=troll+2` will only show moviers that have the phrase `troll 2` in the title or synopsis. This can be accomplished using the `LIKE` and `ILIKE` operators in PostgreSQL. For an additional challenge, use the [full-text search][full_text_search] feature available in PostgreSQL:

```SQL
SELECT * FROM movies WHERE to_tsvector(title) @@ plainto_tsquery('some query here')
```

* Add a search feature for `/actors` that searches through the actor name as well as their roles that they played (found in the `cast_members` table).
* Show the number of movies that each actor has starred in on the `/actors` page. This can be accomplished by using an aggregate query with the `GROUP BY` clause and the `COUNT(*)` function.

### Tips

Since this application will require multiple views it may be easier to organize them in subfolders. For example, the following file structure can be used to separate the movies from the actors:

```no-highlight
views
├── actors
│   ├── index.erb
│   └── show.erb
└── movies
    ├── index.erb
    └── show.erb

2 directories, 4 files
```

To render a particular view in Sinatra, use the following syntax:

```ruby
get '/movies' do
  # ...
  erb :'movies/index'
end
```

[full_text_search]: http://www.postgresql.org/docs/9.1/static/textsearch-intro.html
