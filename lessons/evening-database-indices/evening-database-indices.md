##OMG It's Taking Too Long to Find Our Brussels Sprouts!

###Instructions

We have gigantic database `ingredients` of millions of ingredient records. We want all the rows of ingredients that have Brussels Sprouts in them, but querying them is taking forever. Database indices to the rescue!

###Setup
First create your database called ingredients as follows (from the command line):

`createdb ingredients`

After you have created your `ingredients` table, run the following command from the terminal:

`psql ingredients`

We now need to create the table our exercise cares about. Run the following command while in PostgreSQL:

`create table ingredients (quantity integer, unit varchar(255), name varchar(255));`

Now you have an `ingredients` table in your `ingredients` database. After you have created your `ingredients` table, exit your psql terminal with `\q`. We provide you a `seeder.rb` file which you should run with the following command from the command line:

`ruby seeder.rb`

Let the seeder run for about 20 minutes (could be shorter or longer depending on your machine) until you have 10 million records in your ingredients database. You can check the number of rows you have from your psql terminal with `select count(*) from ingredients;`.

Write an SQL query to
* Find all rows that have an ingredient `name` of `Brussels sprouts`.
* Calculate the total count of rows of ingredients with a `name` of `Brussels sprouts`.
* Find all `Brussels sprouts` ingredients having a unit type of `gallon(s)`.
* Find all rows that have a unit type of `gallon(s)`, a name of `Brussels sprouts` or has the letter `j` in it.

Finally
* Implement a database index to speed up your above SQL queries.

###Learning Goals
* Utilize a database index to speed up SQL queries.
* Get more comfortable with the `psql` console.

###Output
* Submit a markdown file titled `submission.md` that has embedded screenshots depicting a 'before' and 'after' of your query (i.e., without and with an index). Include the SQL queries you wrote to search the database as well as to create the index.

###Tips
* Use the `SQL` query prefix `EXPLAIN ANALYZE` to calculate the total runtime of a query.
* Find more on how to write a markdown file [here](https://help.github.com/articles/markdown-basics/) and [here](https://help.github.com/articles/github-flavored-markdown/).
* Use the following syntax for embedding an image into a markdown file:

```
![alt](http://i.imgur.com/FCq35i5.png)
```

###seeder.rb file

```ruby
require "pg"

UNITS = ["tbspn(s)", "tspn(s)", "gallon(s)", "lb(s)", "kg", "g", "cup(s)"]
NAMES = ["Alfalfa sprouts", "Artichoke hearts", "Arugula", "Avocado", "Beans","Broccoli florets","Cabbage","Cauliflower florets","Celery","Chicory greens","Chinese cabbage","Chives","Cucumber","Daikon radish","Endive","Escarole","Fennel","Greens","Iceberg lettuce","Jicama","Loose-leaf lettuce","Mesclun", "Mung bean sprouts", "Black Olives", "Onion", "Green bell peppers", "Red bell peppers","Radicchio","Radishes","Romaine lettuce","Scallion/green onion","Spinach","Tomato","Watercress","Artichoke","Asparagus","Beans","Beet greens","Bok choy","Broccoflower","Broccoli","Broccoli rabe","Brussels sprouts","Cabbage","Cardoon","Cauliflower","Celery","Swiss Chard","Chayote","Collard greens","Dandelion greens","Eggplant","Escarole","Fennel","Hearts of palm","Kale","Kohlrabi","Leeks","Mustard greens","Cactus pods","Okra","Onion","Pumpkin","Sauerkraut","Scallions","Shallots","Sorrel","Spaghetti squash","Spinach","Summer squash","Tomatillo","Tomato","Water chestnuts","Zucchini","Quorn burger","Quorn roast","Quorn unbreaded cutlet","Seitan","Shirataki soy noodles","Tempeh","Tofu","Blue cheese","Brie","Cheddar or Colby","Cream cheese","Feta","Gouda","Parmesan","Swiss","Skim Milk","Quark","Sour cream","Yogurt","Mayonnaise","Canola Oil","Coconut Oil","Safflower Oil","Flaxseed Oil","Olive Oil","Sesame Seed Oil","Grapeseed Oil","Walnut Oil","Butter","Beer","Bourbon","Champagne","Gin","Rum","Scotch","Sherry","Vodka","Wine","Blackberries","Blueberries","Boysenberries","Cherries","Cranberries","Currants","Gooseberries","Raspberries","Almonds","Almond butter","Almond meal/flour","Brazil nuts","Cashews","Cashew butter","Macadamias","Macadamia butter","Hazelnuts","Peanuts","Peanut butter","Pecans","Pine nuts", "Pistachios", "Pumpkin seeds","Sesame seeds","Sunflower seed butter","Tahini","Walnuts","Blue cheese dressing","Caesar salad dressing","Italian dressing","Lemon juice","Lime juice","Oil and vinegar","Ranch dressing"]

conn = PG.connect(dbname: "ingredients")

starting = Time.now

count = 0
1_000.times do
  sql = "INSERT INTO ingredients (quantity, unit, name) VALUES "
  10_000.times do
    quantity = rand(1..10)
    unit = UNITS.sample
    name = NAMES.sample

    sql += "('#{quantity}', '#{unit}', '#{name}'),"
  end

  sql = sql.chop

  conn.exec(sql)
  total = 10_000*(count + 1)
  total = total.to_s
  puts "added batch #{count + 1} of 10,000 records for a total of #{total.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1#{','}")} records."
  puts "Total time elapsed: #{(Time.now - starting).to_i} seconds."
  count += 1
end

conn.close
```
