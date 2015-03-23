In this article we'll show how we can build forms in a Rails application.

### Learning Goals

* Understand how HTML forms work
* Understand how Rails' `form_for` helper simplifies building forms

### HTML Forms and the Parameters Hash

A basic form in HTML contains a **form** tag that wraps the form fields and a number of **input** tags, one for each field and one for the submit button. It may also include other tags, such as **select** tags for drop-down select menus, but for simplicity's sake we'll restrict our discussion to simple `<input>` tags.

When a form is submitted, the data entered into the fields are encoded and serialized and sent to the web server. When the web server receives a request with form **parameters**, it stores them in a hash that is accessible via the controller handling the request.

The attributes on the `<form>` and `<input>` tags determine what HTTP request will be sent and how the information from the form will be stored in the parameters hash. Let's take a closer look at how this works.

Each `<form>` tag will contain two key attributes that determine what happens when we submit the form: the **action** attribute, which provides the path or route, and the **method**, or HTTP verb. A `<form>` tag can contain other attributes, but these are the two we're most interested in.

A form for creating a new book in a Rails app, for example, might look something like this:

```html
<form action="/books" method="post" ...>
  <!-- a bunch of input fields & corresponding labels -->
  <input type="submit" ...>
</form>
```

When the form is submitted, an HTTP `POST` request is sent to the `/books` path. (This will trigger the `create` action on the `BooksController` to create a new book. We'll talk more about that in subsequent assignments.)

The **name** attribute on the `<input>` tag determines how that information is stored in the parameters hash. For example, consider the following form to create a new book:

```html
<form action="/books" method="post" ...>
  <label>Author</label>
  <input name="book[author]" type="text"...>

  <label>Title</label>
  <input name="book[title]" type="text"...>

  <input type="submit" ...>
</form>
```

Our parameters hash would include a key-value pair with `book` as the key and a hash containing the keys `author` and `title`. If we filled in the form with the title "Green Eggs and Ham" and author "Dr. Seuss", our parameters hash should include a key-value pair that looks like this:

```no-highlight
"book"=>{"author"=>"Dr. Seuss", "title"=>"Green Eggs and Ham"}
```

*Note:* If we did not set the name attribute on an input field, it would not be included in the parameters hash.

### Rails form_for Helper

Rails provides us with some **helpers** to make creating forms in our views easier. **Helpers**, in this context, are methods Rails provides that help us to quickly generate HTML markup.

Let's take a look at one of these helpers which gets used a lot: **form_for**. The `form_for` helper creates your form for you: it creates the `<form>`, `<label>`, `<input>`, and other tags for you, all with the appropriate attributes.

To check out `form_for` in action, let's quickly create an app called Library. It should have a single scaffolded model `Book`, with `:title` and `:author` attributes:

```no-highlight
$ rails new library
$ cd library
$ rake db:create
$ rails generate scaffold book author:string title:string
$ rake db:migrate && rake db:rollback && rake db:migrate
```

Now open up the app in an editor and check out the form partial for creating or editing a book at `app/views/books/_form.html.erb`. Ignoring the stuff at the top about errors, we can see that our form looks like this:

```erb
<%= form_for(@book) do |f| %>
  <div class="field">
    <%= f.label :author %><br>
    <%= f.text_field :author %>
  </div>

  <div class="field">
    <%= f.label :title %><br>
    <%= f.text_field :title %>
  </div>

  <div class="actions">
    <%= f.submit %>
  </div>
<% end %>
```

The `form_for(@book)` helper creates the outline of the form and additional methods are called to create the labels and input fields for each attribute on our `Book` model.

When this partial is rendered in the browser, this erb will be rendered as an HTML form like we saw above. To see this, fire up your `rails server` and navigate to [http://localhost:3000/books/new](http://localhost:3000/books/new). If you inspect the source using your browser's inspector, you should find the following:

```html
<form accept-charset="UTF-8" action="/books" class="new_book" id="new_book" method="post">
  <div style="margin:0;padding:0;display:inline">
    <input name="utf8" type="hidden" value="&#x2713;" />
    <input name="authenticity_token" type="hidden" value="J4d4+QxteoTzmoHWFLDOAGTRnZnWTCLujlGQidriRXQ=" />
  </div>

  <div class="field">
    <label for="book_author">Author</label><br>
    <input id="book_author" name="book[author]" type="text" />
  </div>

  <div class="field">
    <label for="book_title">Title</label><br>
    <input id="book_title" name="book[title]" type="text" />
  </div>

  <div class="actions">
    <input name="commit" type="submit" value="Create Book" />
  </div>
</form>
```

You can see that our `form_for` invocation has created a `<form>` tag with the action `/books` and the method `post`, and `<input>` fields with the names `book[author]` and `book[title]`, in addition to some other stuff that you don't need to worry about for now.

Fill in the form and click "Create Book". Inspect the output in the terminal where you're running your server. You should see an entry something like this:

```no-highlight
Started POST "/books" for 127.0.0.1 at 2014-03-21 10:26:20 -0400
Processing by BooksController#create as HTML
  Parameters: {"utf8"=>"✓", "authenticity_token"=>"J4d4+QxteoTzmoHWFLDOAGTRnZnWTCLujlGQidriRXQ=", "book"=>{"author"=>"Dr. Seuss", "title"=>"Green Eggs and Ham"}, "commit"=>"Create Book"}
   (0.1ms)  begin transaction
  SQL (0.4ms)  INSERT INTO "books" ("author", "created_at", "title", "updated_at") VALUES (?, ?, ?, ?)  [["author", "Dr. Seuss"], ["created_at", Fri, 21 Mar 2014 14:26:20 UTC +00:00], ["title", "Green Eggs and Ham"], ["updated_at", Fri, 21 Mar 2014 14:26:20 UTC +00:00]]
   (0.7ms)  commit transaction
Redirected to http://localhost:3000/books/7
Completed 302 Found in 6ms (ActiveRecord: 1.2ms)
```

This log is telling us that when we clicked "Create Book", an HTTP POST request was sent to the `/books` path, and that this request was processed by the `create` action on the `BooksController`. It also shows us that the values we supplied were sent as part of the parameters hash:

```no-highlight
Parameters: {"utf8"=>"✓", "authenticity_token"=>"J4d4+QxteoTzmoHWFLDOAGTRnZnWTCLujlGQidriRXQ=",
"book"=>{"author"=>"Dr. Seuss", "title"=>"Green Eggs and Ham"}, "commit"=>"Create Book"}
```

And that a new record was inserted into our database:

```no-highlight
SQL (0.4ms)  INSERT INTO "books" ("author", "created_at", "title", "updated_at") VALUES (?, ?, ?, ?)
[["author", "Dr. Seuss"], ["created_at", Fri, 21 Mar 2014 14:26:20 UTC +00:00],
["title", "Green Eggs and Ham"], ["updated_at", Fri, 21 Mar 2014 14:26:20 UTC +00:00]]
```

### Using form_for

Let's take a closer look at how `form_for` works. At the top of the form, you see the `form_for` invocation:

```
<%= form_for(@book) do |f| %>
```

Let's first take the argument passed into the `form_for` invocation: `@book`. This argument informs several aspects of the form, including:

**The fields that can be included in the form.** `@book` does not have an `:isbn_number` attribute, for example, so if we added `f.text_field :isbn_number` to our form, we should see an error when the form is rendered in the browser.

**The path and HTTP verb the form uses.** Recall that the form partial is used in two places: once for creating new book instances, and once when we need to edit or update existing book instances. In the case of creating a new book, we want to generate a `POST /books` request. In the case of updating a book, we want to generate a `PATCH  /books/1` request, where we are updating the attributes of the book with ID 1. If `@book` is already persisted in the database, the form will submit a PUT or PATCH request to `/books/:id`, whereas it will submit a POST to `/books` if the record is not persisted.

*Note:* Not all browsers and webservers support the PUT and PATCH operations. Despite these HTTP verbs being a part of the protocol, they have not until recently been put to significant use. To handle this, Rails builds in a way to emulate a PUT or PATCH HTTP request. This is all managed for you via the `form_for` invocation.

Now let's look at the `|f|`. The `form_for` method requires that a block be passed to it. In this case, the block is supplied an argument `f` that is the current form object. We can invoke **instance methods** on this object to build labels, text fields, textareas, and other inputs:

```ruby
# label and text_field are instance methods of the form object
f.label :name_of_field
f.text_field :name_of_field
```

### Resources

* [HTML forms guide](https://developer.mozilla.org/en-US/docs/Web/Guide/HTML/Forms)
* [Rails Guides Form Helpers](http://guides.rubyonrails.org/form_helpers.html)
