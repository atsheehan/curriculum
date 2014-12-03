CREATE TABLE recipes (
  id serial PRIMARY KEY,
  name varchar(255) NOT NULL,
  directions varchar(4000) NOT NULL,
  servings integer,
  prep_time_in_min integer,
  cooking_time_in_min integer,
  category_id integer NOT NULL
);

CREATE TABLE ingredients (
  id serial PRIMARY KEY,
  recipe_id integer NOT NULL,
  name varchar(255) NOT NULL,
  quantity integer,
  unit varchar(255)
);

CREATE TABLE categories (
  id serial PRIMARY KEY,
  name varchar(255) NOT NULL
);

INSERT INTO categories (name) VALUES ('Italian'), ('Indian'), ('Thai');

INSERT INTO recipes (name, directions, servings
