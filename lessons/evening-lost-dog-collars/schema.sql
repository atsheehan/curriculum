CREATE TABLE dog_owners (
  id serial,
  name varchar(255) NOT NULL,
  dog_name varchar(255) NOT NULL
);

CREATE TABLE lost_dog_collars (
  id serial,
  dog_name varchar(255) NOT NULL
);

INSERT INTO dog_owners (name, dog_name)
  VALUES (
    'Omid', 'Bronson'
  );

INSERT INTO dog_owners (name, dog_name)
  VALUES (
    'Evan', 'Boogie'
  );

INSERT INTO dog_owners (name, dog_name)
  VALUES (
    'Whitney', 'Gilly'
  );

INSERT INTO dog_owners (name, dog_name)
  VALUES (
    'Spencer', 'Lilly'
  );

INSERT INTO dog_owners (name, dog_name)
  VALUES (
    'Dan', 'Apple'
  );

INSERT INTO dog_owners (name, dog_name)
  VALUES (
    'Dan', 'Linux'
  );

INSERT INTO lost_dog_collars (dog_name)
  VALUES (
    'Boogie'
  );

INSERT INTO lost_dog_collars (dog_name)
  VALUES (
    'Lassie'
  );

INSERT INTO lost_dog_collars (dog_name)
  VALUES (
    'Gilly'
  );

INSERT INTO lost_dog_collars (dog_name)
  VALUES (
    'Lilly'
  );

INSERT INTO lost_dog_collars (dog_name)
  VALUES (
    'Fido'
  );

INSERT INTO lost_dog_collars (dog_name)
  VALUES (
    'Linux'
  );

INSERT INTO lost_dog_collars (dog_name)
  VALUES (
    'Bronson'
  );

INSERT INTO lost_dog_collars (dog_name)
  VALUES (
    'Goose'
  );
