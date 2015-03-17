In this unit, you'll begin to work with associations - a way of dividing data rationally among multiple tables.

### Learning Goals

* Create a multi-table application
* Explore ways to associate tables
* Use a foreign key column

### Resources

* [Rails Guide to ActiveRecord Associations][railsguides-associations]

### Implementation Notes

In a family, a parent has zero or more children; a directory on a hard drive contains zero or more files; a house contains one or more rooms. We intuitively understand the hierarchical nature of these relationships.

This type of relationship often comes up in our data as well. A blog has one or more articles; an article has zero or more comments; a user has zero or more comments. These are known as **one-to-many** relationships and in this assignment we'll begin to look at how to represent these relationships in our applications.

#### Enter the Blogosphere

Let's create a new Sinatra app. You can use the [Sinatra ActiveRecord Starter Kit](sinatra-starter) as a base for your app. Follow the instructions in the [Getting Started](https://github.com/LaunchAcademy/sinatra-activerecord-starter-kit#getting-started) section of the README, calling your app "blog".

**Hint: Don't forget to create your database with `rake db:create` after configuring your database.**

#### Creating Articles

To begin, we'll create an `Article` model:

```ruby
# app/models/article.rb

class Article < ActiveRecord::Base
end
```

Notice that the `Article` class inherits from `ActiveRecord::Base`. By inheriting from this class, we gain access to the methods defined in `ActiveRecord::Base`, which will allow us to create, update, read, and delete object data in our database. `ActiveRecord` and Postgres provide us with a layer of persistence for our objects, so that the data associated with our objects is saved, even when our application isn't running.

The `Article` class is saved under the `app/models` folder. This corresponds to the `M` in the MVC design pattern.

For every model in our `app/models` folder, we need an associated table in our database. Let's create a migration to handle creating the corresponding `articles` table with `rake db:create_migration NAME=create_articles`.

Inside the generated `db/migrate/xxxxx_create_articles.rb`:

```ruby
# db/migrate/xxxxx_create_articles.rb

class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |table|
      table.string :subject, null: false
      table.text :story, null: false

      table.timestamps
    end
  end
end
```

After creating our database and running `rake db:migrate`, we should have our `articles` table.

Notice the naming conventions here. The `Article` model is singular, while the `articles` table is plural. Adhering to this naming convention is important, since `ActiveRecord` uses the plural form of the model name to find the associated table in the database. The [`ActiveSupport::Inflector`](activesupport-inflector) class handles the singularization or plurilazation of words. Check out the [ActiveRecord Naming Challenge](activerecord-challenge) if you would like to practice your ability to adhere to `ActiveRecord` naming conventions.

#### Creating Comments

We also want to let people comment on our articles, which we'll store in a separate `comments` table. A comment should have some text associated with it but it also needs to be associated with a article, somehow. We can accomplish this by creating a **foreign key** from our `comments` table back to our `articles` table.

To begin, we'll create a `Comment` model:

```ruby
# app/models/comment.rb

class Comment < ActiveRecord::Base
end
```

And then we'll create a migration to handle creating the corresponding `comments` table in the database with `rake db:create_migration NAME=create_comments`.

Inside the generated `db/migrate/xxxxx_create_comments.rb`:

```ruby
# db/migrate/xxxxx_create_comments.rb

class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |table|
      table.integer :article_id, null: false
      table.text :body, null: false

      table.timestamps
    end
  end
end
```

**Migrate the database again to finish creating the `comments` table.**

Notice how we included the `article_id:integer` attribute in our model. The `article_id` column on the `comments` table refers to the `id` column on the `articles` table. In this scenario, `article_id` is the _foreign key_ and `id` is the _primary key_. This enables us to have a single record in the `articles` table that corresponds to zero or more records in the comments table.

#### Creating Some Records

Let's load up our app in an irb (or pry if you want syntax highlighting!) console session and create some records in our database.

**You can fire up an irb session and require all of your app with `irb -r ./app.rb`.**

Run the following commands in your irb session:

```ruby
cat_article = Article.create(subject: "Some thoughts about cats", story: "They're OK.")
ruby_article = Article.create(subject: 'Ruby vs. Python', story: 'Ruby wins cause I said so.')

Comment.create(body: 'LOL', article_id: cat_article.id)
Comment.create(body: 'click here for a free iPad!', article_id: cat_article.id)

Comment.create(body: 'great analysis!!!', article_id: ruby_article.id)
Comment.create(body: 'ruby is so 2010, Go is the future', article_id: ruby_article.id)
Comment.create(body: 'i like ice cream', article_id: ruby_article.id)
```

Here we created two separate articles with two and three comments, respectively. The `create` method is something we gained by inheriting from `ActiveRecord::Base`. This method saves a record to the database. We could achieve the same result by using the `new` method to initialize a new `ActiveRecord` object, passing in the attributes we want to set, and then calling the `save` method on the object. Notice that when we created the comment, all we had to do was give it the ID of the article that it belonged to so that the foreign key was setup correctly.

#### Retrieving associated records using ActiveRecord queries

Now that we have our data, how can we retrieve it? Let's pull all of the comments for our article about cats:

```ruby
article = Article.where(subject: 'Some thoughts about cats').first
comments = Comment.where(article_id: article.id)
```

We first retrieve the article based on the subject using our `where(subject: 'Some thoughts about cats').first` method and then we query for comments using `where(article_id: article.id)`. We're first finding the **primary key** of the article and then matching that to the **foreign key** on the comments table.

**Quick challenge:** Retrieve the article associated with the comment "i like ice cream".

This is a very common operation in Rails: starting with some record, list all of its associated records (e.g. find a user and list all of their friends, find a movie and list all of the cast, etc.). We can use [ActiveRecord Associations][railsguides-associations] to make this process much easier.

#### Using ActiveRecord associations

ActiveRecord provides a number of different types of associations. Here, we'll look at two associations that are used to establish a one-to-many relationship: [has_many](railsguides-has_many) and [belongs_to](railsguides-belongs_to).

##### has_many

In our `Article` model, we can let ActiveRecord know about the one-to-many relationship:

```ruby
class Article < ActiveRecord::Base
  has_many :comments
end
```

The `has_many` method will set up our association between the `Article` and the `Comment` model. By saying that `article` "has many" comments, it is expecting to find a model named `Comment` that has a `article_id` attribute.

We can test our new association by loading up our app in an irb session and running the following command:

```ruby
article = Article.first
article.comments
```

The line `article.comments` will return the same records that `Comment.where(article_id: article.id)` returns. By following conventions (i.e. naming our foreign key `article_id` after the model name), we can benefit from these shortcuts that Rails provides.

##### belongs_to

In addition to a `Article` having many `Comment`s, a `Comment` also has the inverse relationship with its `Article`. Given a `Comment`, we can find the `Article` that it belongs to using the following:

```ruby
comment = Comment.first
article = Article.where(id: comment.article_id).first
```

With ActiveRecord, we can define this relationship to make querying for the
`article` a bit easier.

```ruby
class Comment < ActiveRecord::Base
  belongs_to :article
end
```

Here we've defined the relationship between our `Comment` and the `Article`: the `Comment` belongs to the `Article`. Doing this provides the `Article` method on instance of the `Comment` class for easy lookup:

```ruby
comment = Comment.first
comment.article
```

This returns the same record as `Article.where(id: comment.article_id).first` did except we have to use far less syntax. ActiveRecord makes manipulating our records much simpler to the point where we don't have to deal with SQL on a regular basis and can instead focus on using our objects and the relationships between them.

### Rules to Follow

#### Use `has_many` and `belongs_to`, together

If an article has many comments, it follows that a comment belongs to an article. We should define the association `has_many :comments` in the `Article` model, __and__ define the `belongs_to :article` association in the `Comment` model. You should not declare one without the other.

#### (Almost) Always Use IDs For Foreign Keys

SQL doesn't actually require that we use numeric integers for foreign keys but for our applications it is usually the preferred method. We could have also linked our comments to the articles via the subject line if we wanted to: instead of `article_id` we could have used `article_subject` where we stored the subject of the article with each comment. The problem is that the author might edit the subject at some point and break that link between the article and the comments. It's best to stick with using numeric IDs that are auto-assigned by the database. These IDs are never re-used or changed once they are assigned so it ensures that the relationships between objects do not get mixed up.

### Why This Matters

#### Using Rails' Association Tools Makes for More Consistent, Readable Code

The most striking thing about associations is how readable they make relationships between objects. Once you become acclimated to their use, you'll start to examine models by looking at how their declared associations work, their relations to dependents, as well as their validations and scopes. A single line of code in a model can tell you an enormous amount about a database relationship.

[activesupport-inflector]: http://api.rubyonrails.org/classes/ActiveSupport/Inflector.html
[activerecord-challenge]: http://ar-naming.herokuapp.com/
[railsguides-associations]: http://guides.rubyonrails.org/association_basics.html
[railsguides-has_many]: http://guides.rubyonrails.org/association_basics.html#the-has-many-association
[railsguides-belongs_to]: http://guides.rubyonrails.org/association_basics.html#the-belongs-to-association
[sinatra-starter]: https://github.com/LaunchAcademy/sinatra-activerecord-starter-kit
