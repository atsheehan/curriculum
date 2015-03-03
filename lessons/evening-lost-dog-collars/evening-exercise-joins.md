# Dog Park: Lost and Found

OMG Our dogs are having so much fun playing at the dog park that they're losing their collars. After a busy weekend at the dog park, the staff at the Lost and Found counter are determined to empty their storage of these crucial bits of lost property. Collars with ID contain valuable information, such as the details to find the loving owner of a pup and the vaccinations required to be displayed in public. We have a mission.

Larry, the developer on the the Lost and Found team, is going to open up PostgreSQL and start reconnecting dog owners with dog collars. He will find two tables already in our database:

### Dog Owners Table

This table contains the names of people and their dog, as contained in the sign in sheet at the front desk.

| id |  name   | dog_name
|----|---------|----------
|  1 | Omid    | Bronson
|  2 | Evan    | Boogie
|  3 | Whitney | Gilly
|  4 | Spencer | Lilly
|  5 | Dan     | Apple
|  6 | Dan     | Linux

### Found Dog Collars Table

This table contains the names of dogs found on collars in the Lost and Found office.

| id | dog_name  
|----|----------  
|  1 | Boogie  
|  2 | Lassie  
|  3 | Gilly  
|  4 | Lilly  
|  5 | Fido  
|  6 | Linux  
|  7 | Bronson  
|  8 | Goose  

### Where do we start?

To successfully start this mission, Larry needs to make some connections between the two tables. SQL Joins are important tools in making this possible. He starts with this query:

```SQL  
SELECT dog_owners.name, lost_dog_collars.dog_name  
  FROM dog_owners  
  JOIN lost_dog_collars  
  ON (dog_owners.dog_name = lost_dog_collars.dog_name);
```

Here is what he got:

|  name   | dog_name
|---------|----------
| Evan    | Boogie
| Whitney | Gilly
| Spencer | Lilly
| Dan     | Linux
| Omid    | Bronson

What does this query tell us? Larry has hired you as an outside consultant to do him a solid and help him answer some concrete questions. To help him, you need to see a list of join types and also see a list of questions that can be answered using those joins.

### Joins

Here are some possible joins we can use:

```SQL
INNER JOIN
LEFT JOIN
RIGHT JOIN
FULL OUTER JOIN
LEFT OUTER JOIN
RIGHT OUTER JOIN
```

### What Larry needs to know

1. For which collars can we identify an owner?
2. For which collars is there no known owner?
3. We need to see all collars, with an owner, if one matches.
4. We need to see all owners, with collars in the Lost and Found, if one matches.

Good luck!
