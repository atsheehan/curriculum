### Instructions

Write a web application to manage a grocery list. It should display the groceries currently on the list and provide a form for adding a new item to buy.

#### Requirements

The application should satisfy the following requirements:

* Visiting `GET /groceries` should display a list of groceries to purchase as well as a form for adding a new grocery item.
* The form to add a new grocery item only requires the name to be specified.
* The list of groceries is read from the `grocery_list.txt` file which stores each item on a new line.
* The form submits to `POST /groceries` which saves the new item to the `grocery_list.txt` file.

### Learning Goals

* Generate a dynamic web page in response to a `GET` request.
* Persist information from a user submitted via a `POST` request.

### Sample Output

Below is an example of what the application should look like:

![Grocery List][sample-app]

### Tips

To avoid losing past information you'll probably want to **append** to a file rather than overwrite. You can open a file for appending and write a new line to it with the following snippet of code:

```ruby
File.open("some-file.txt", "a") do |f|
  f.write("blah\n")
end
```

[sample-app]: https://s3.amazonaws.com/hal-assets.launchacademy.com/grocery-list/groceries.png
