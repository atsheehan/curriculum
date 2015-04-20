### Overview

We've been getting a lot of feedback from our users saying that they are not happy with the way that the page refreshes every time that they "Meow" at a post because they lose their place on the page. We can fix this by using some jQuery to have our "Meow" button forms submit asynchronously via [Ajax](http://api.jquery.com/jquery.ajax/).

### Guiding Questions

* How can we use Rails to respond to JSON requests?
* How can we use JavaScript & jQuery to manipulate the content of a page?
* How can we use jQuery to find specific elements on our pages?
* What does it mean for a request to be asynchronous?

### Learning Objectives

* Use JavaScript and jQuery to manipulate the DOM
* Become familiar with the idea of asynchronous requests

### Prework

- Read [JQuery Fundamentals: AJAX & Deferreds](http://jqfundamentals.com/chapter/ajax-deferreds) down to "Sending data & working with forms."
- Fork [Catstagram](https://github.com/LaunchAcademy/catstagram) on Github
- Set up Catstagram on your machine
- Verify that all of the tests are passing
- Seed your development database with `rake db:seed`

#### Getting Familiar with the Project

[Catstagram](https://github.com/LaunchAcademy/catstagram) is like Instagram, but for images of cats. Users can post pictures of cats and other users can "Meow" if they like the picture.

We've been getting a lot of feedback from our users saying that they are not happy with the way that the page refreshes every time that they "Meow" at a post because they lose their place on the page. We can fix this by using some jQuery to have our "Meow" button forms submit asynchronously via [Ajax](http://api.jquery.com/jquery.ajax/).

We're going to make this change in a few different steps:

- Make the "Meow" button submit asynchronously
- Replace the "Meow" button with the "Remove Meow" button when pressed
- Make the "Remove Meow" button submit asynchronously
- Replace the "Remove Meow" button with the "Meow" button when pressed
- Increment the meow count when the "Meow" button is pressed
- Decrement the meow count when the "Remove Meow" button is pressed

You'll be walked through the first 4 steps but you'll need to implement the last two on your own.

### Making the "Meow" button submit asynchronously

The first step is to make the "Meow" button submit asynchronously, that is, without reloading the page. Start by creating a new Javascript file, `app/assets/javascripts/catstagram.js`. This file will automatically be loaded into our `app/views/layouts/application.html.erb` because of the `//= require_tree .` statement in our `app/assets/javascripts/application.js`, which automatically requires any Javascript files that we place in our `app/assets/javascripts` directory.

Our `application.js` is included into our layout from the following line, which you
should find in the `<head>` tag:

```ruby
<%= javascript_include_tag "application", "data-turbolinks-track" => true %>
```

We'll start by writing a [jQuery document ready block](http://learn.jquery.com/using-jquery-core/document-ready/), which we will write all of our code inside of. This prevents our code from
running until all of the HTML elements have been loaded into the [DOM](https://developer.mozilla.org/en-US/docs/DOM/DOM_Reference/Introduction)
(onto the page).

```javascript
// app/assets/javascripts/catstagram.js

$(document).ready(function() {
  // we will write all of our code here
  alert('it works!');
});
```

Now, since our "Meow" buttons are actually submit inputs for forms, we're going to want to trigger our Javascript when those forms are submitted. In order to trigger some Javascript code to run when our "Meow" form is submitted, we will add a jQuery event handler to listen for our form being submitted.

In order to target the `<form>` that our "Meow" button is a part of, we're going to add an [HTML5 data attribute](http://html5doctor.com/html5-custom-data-attributes/) to the `<form>`. tag. Though we could use a class or id, I like to use data attributes when adding markup that is strictly for Javascript and use classes and ids for styling as much as possible.

```html
<!-- app/views/posts/index.html.erb -->

<%= button_to "Meow", post_meows_path(post),
  method: :post,
  # This hash will add a `data-meow-button="create"` to the generated form
  form: { data: { 'meow-button' => 'create' } } %>
```

The generated HTML for the new "Meow" button will now look like this:

```html
<form action="/posts/3/meows" class="button_to" data-meow-button="create" method="post">
  <div>
    <input type="submit" value="Meow">
    <input name="authenticity_token" type="hidden" value="L4JnCCMmwBprW3rh5S1j8Zp2rFuCqt16AZymqPCWhB0=">
  </div>
</form>
```

Now that we can target the `<form>` for creating a `Meow` using a data attribute, let's add our first event listener. We're going to be using [jQuery's .on()](http://api.jquery.com/on/) function to listen for the `submit` event of our `<form>`.

```javascript
// app/assets/javascripts/catstagram.js

$(document).ready(function() {
  $('[data-meow-button="create"]').on('submit', function(event) {
    event.preventDefault();
    alert('MEOW!');
  });
});
```

Let's talk about what we're doing there. We're saying to find all of the elements on the page that have a `data-meow-button` attribute and listen for the `submit` event. When a `submit` event occurs, run an [anonymous function](http://helephant.com/2008/08/23/javascript-anonymous-functions/)(without a name), passing in the submit event itself as an argument. Inside the anonymous function we call `event.preventDefault();`, which basically says to prevent the default action of submitting the form, which would cause the page to be refreshed. Then we just create an `alert` so we can see if what we have is working. Go ahead, try it out.

Of course, preventing the form from actually submitting is not what we want to do. We still want to send the request to the server but we want to do it in the background, asynchronously.

Before we can create our [Ajax request](http://api.jquery.com/jquery.ajax/), we're going to want to get the form object into a variable so we can use it's attributes as the parameters of our request.

```javascript
// app/assets/javascripts/catstagram.js

$(document).ready(function() {
  $('[data-meow-button="create"]').on('submit', function(event) {
    event.preventDefault();

    $form = $(event.currentTarget);
  });
});
```

Here we're using `event.currentTarget()` to find the element that is the target of the event that is passed into the function. We wrap it in `$()` so that we get the [jQuery object](http://learn.jquery.com/using-jquery-core/jquery-object/) version of the DOM element. It's stored in a variable prefixed with `$` because that it the convention for signifying that the variable contains a jQuery object.

Now that we have the form stored in a variable, we can send an Ajax request in the background using it's attributes using jQuery's `$.ajax()` function. This will cause a POST request to be sent to `/posts/:post_id/meows`, which maps our `meows#create` action.

```javascript
// app/assets/javascripts/catstagram.js

$(document).ready(function() {
  $('[data-meow-button="create"]').on('submit', function(event) {
    event.preventDefault();

    $form = $(event.currentTarget);

    $.ajax({
      type: "POST",
      url: $form.attr('action'),
      dataType: "json"
    });
  });
});
```

Here we're using the jQuery `$.ajax()` function to send a POST request to the URL specified in the `action` attribute of our form (`/posts/:post_id/meows`), and we're specifying that it's going to be a 'json' request. As you might have realized, other than the request type being 'json', this is the same kind of request that our form would normally send and corresponds to our `meows#create` action.

**Hint:** If you're using Chrome, you can leave the "Network" tab of the "Developer Tools" console open and watch the requests going through in the background.

### Replacing the "Meow" button with the "Remove Meow" button

Your "Meow" button should now be working without reloading the page but now you need to manually reload the page in order for the "Meow" button to change to the "Remove Meow" button. In order to fix this issue, we can take advantage of another feature of jQuery's `$.ajax()` function, the `success` callback.

The `$.ajax()` function allows us to specify another function that should run when the request is completed and the server responds with a successful status code. Because of the asynchronous nature of the `$.ajax` function, it's important that we use the `success` function in order to make sure that this code is not run until a successful response is returned from the server.

In our case, when the `Meow` is created successfully. We can use the `success` callback to do some DOM manipulation and replace the "Meow" button with the "Remove Meow" button.

Let's start small and add an `alert` to make sure that we've got everything set up correctly:

```javascript
// app/assets/javascripts/catstagram.js

$(document).ready(function() {
  $('[data-meow-button="create"]').on('submit', function(event) {
    event.preventDefault();

    $form = $(event.currentTarget);

    $.ajax({
      type: "POST",
      url: $form.attr('action'),
      dataType: "json",
      success: function() {
        alert("MEOW"); // This won't work yet!
      }
    });
  });
});
```

If you try this out in your browser, you'll see that the `alert` is not working. The reason that the alert isn't working has to do with the status code of the response from the server. If you're using Chrome, you can leave the "Network" tab of the "Developer Tools" console open and watch the requests going through in the background as you click on the "Meow" button. You'll see that the status code that we're getting back from the server is "302 Found". The `success` handler of the `$.ajax()` function is looking for a response of "200 Found".

To respond successfully to a json request, we're going to need to modify our `MeowsController#create` action to respond differently when it receives a json request.

```ruby
# app/controllers/meows_controller.rb

# old create method
if meow.save
  redirect_to :back, notice: "We heard your Meow!"
else
  redirect_to :back
end

# new create method
respond_to do |format|
  if meow.save
    format.html { redirect_to :back, notice: "We heard your Meow!" }
    format.json { render json: meow }
  else
    format.html { redirect_to :back }
    format.json { render json: meow.errors, status: :unprocessable_entity }
  end
end
```

The `respond_to` block allows us to specify different lines of code to run depending on the format of the request that is received. When the request format is html, we do the same thing we were doing before. When the request format is JSON, we `render` the `meow` object as a JSON hash if the `meow` is saved successfully and we send back the `meow.errors` hash as a JSON hash if the `meow` is not saved successfully.

*Note: This is almost exactly what a Rails scaffold would give you.*

If you watch the "Network" tab in the Chrome developer tools while you click on the "Meow" button now, you can inspect the response and see the JSON hash that is sent back from a successful request. It should look like the following:

![JSON Response when creating a Meow](https://dl.dropboxusercontent.com/s/tizedkijf2ihmef/Screen%20Shot%202014-01-06%20at%205.47.50%20AM.png)

We can get access to this object by assigning it as an argument in our `success` handler.

```javascript
// app/assets/javascripts/catstagram.js

$.ajax({
  type: "POST",
  url: $form.attr('action'),
  dataType: "json",
  success: function(meow) {
    debugger;
  }
});
```

**Hint**: You can use Javascript's built in pry-like `debugger` by adding a `debugger` statement like in example above and clicking on the "Meow" button while your Chrome Developer Tools console is open. Try it out and use the console to inspect the `meow` object.

Alright great, the our `success` handler works. Now we can move on to actually replacing the "Meow" button with a "Remove Meow" button.

The first step to replacing the "Meow" button with a "Remove Meow" button is to create the new "Remove Meow" button. Doing this by hand is somewhat clunky but this is the most basic way of getting this done without the hassle of setting up some kind of templating framework.

```javascript
// app/assets/javascripts/catstagram.js

$.ajax({
  type: "POST",
  url: $form.attr('action'),
  dataType: "json",
  success: function(meow) {
    // Create the String version of the form action
    action = '/posts/' + meow.post_id + '/meows/'+ meow.id;

    // Create the new form
    $newForm = $('<form>').attr({
      action: action,
      method: 'delete',
      'data-meow-button': 'delete'
    });

    // Create the new submit input
    $meowButton = $('<input>').attr({type: 'submit', value: 'Remove Meow'});

    // Append the new submit input to the new form
    $newForm.append($meowButton);

    // Replace the old create form with the new remove form
    $form.replaceWith($newForm);
  }
});
```

**Note**: The "Remove Meow" button that replaces your "Meow" button won't work yet because submitting it will not actually send a "delete" request. Submitting forms using HTTP methods other than GET and POST is not widely supported by browsers so Rails has the convention of adding a hidden `<input>` tags to forms in order to use the other HTTP methods. Since we're going to be sending the request via AJAX anyway, where we can make use of any of the HTTTP methods, I'd rather skip adding the extra code to create that element.

### Making the "Remove Meow" button submit asynchronously

Now that our "Meow" button is working asynchronously, we need to do the same with the "Remove Meow" button. We'll start again by adding a data attribute to the "Remove Meow" buttons in our Rails view.

```html
<!-- app/views/posts/index.html.erb -->

<%= button_to "Remove Meow", post_meow_path(post, post.meow_from(current_user)),
  method: :delete,
  form: { data: { 'meow-button' => 'delete' } } %>
```

And then we'll create an event listener for those buttons.

```javascript
// app/assets/javascripts/catstagram.js

$(document).ready(function() {
  $('[data-post-id]').on('submit', '[data-meow-button="create"]', function(event) {
    // omitted
  });

  $('[data-meow-button="delete"]').on('submit', function(event) {
    event.preventDefault();

    $form = $(event.currentTarget);

    $.ajax({
      type: "DELETE",
      url: $form.attr('action'),
      dataType: "json",
      success: function() {
        alert('MEOW DELETED!');
      }
    });
  });
```

Take a minute or two to experiment in the browser clicking on the "Meow" and "Remove Meow" buttons while the Chrome Developer Tools is open to the "Network" tab. You'll notice our asynchronous requests to the `MeowsController#destroy` action are, just like earlier with the `MeowsController#create` action, sending back a response with status code "302 Found". Again, to fix this we need to update our `MeowsController#destroy` action to handle responding to JSON requests and send the correct status code.

```ruby
# app/controllers/meows_controller.rb

def destroy
  current_user.meows.destroy(params[:id])

  respond_to do |format|
    # Respond the same way we were before if the request format is html
    format.html do
      flash[:notice] = "All evidence of your meowing has been destroyed!"
      redirect_to :back
    end

    # Respond with a "204 No Content" to signify that the request has been
    # fulfilled
    format.json { head :no_content }
  end
end
```

Again, take a minute or two to experiment with the buttons in the browser. You'll notice that the "Remove Meow" buttons that are on the page when it first loads work correctly and display the alert upon `success` but the ones that we're replacing the "Meow" button with don't.

The reason for this is kind of a tricky concept to understand but is something that you'll run into often when using Javascript. If you remember back to when we first started adding Javascript to the application, we wrapped our code in a jQuery document ready block. We did this because we cannot add event listeners to elements that are not yet loaded into the DOM. We need to make sure we wait until after it's loaded to start adding our event listeners.

In order to make sure that our event listeners will also apply to the buttons that are added to the DOM after the initial page load, we want to instead add them to parent elements of the "Meow" and "Remove Meow" buttons.

Start by adding a `<div>` tag that wraps all of the HTML elements responsible for displaying each of our `Post`s in the DOM. Each of these `<div>` tags should have a data attribute that will signify that this `<div>` and it's contents represent a `Post` as well as tell us the `id` of that `Post`.

```html
<!-- app/views/posts/index.html.erb -->

<% @posts.each do |post| %>
  <!-- A wrapper element for each Post that also has the value of the Post's id -->
  <div data-post-id="<%= post.id %>">
    <%= image_tag post.image.url %>

    <p><%= pluralize post.meows.count, "Meow" %></p>

    <% if user_signed_in? %>
      <% if post.has_meow_from?(current_user) %>
        <%= button_to "Remove Meow", post_meow_path(post, post.meow_from(current_user)),
          method: :delete,
          form: { data: { 'meow-button' => 'delete' } } %>
      <% else %>
        <%= button_to "Meow", post_meows_path(post),
          method: :post,
          form: { data: { 'meow-button' => 'create' } } %>
      <% end %>
    <% end %>

    <p><%= post.description %></p>
  </div>
<% end %>
```

Since this parent wrapper `<div>` will not be changing after the page loads, we can add our event listener to it instead, allowing the event listener to still listen for events fired by elements that we add to the DOM after the initial page load.

```javascript
// app/assets/javascripts/catstagram.js

// Add an event listener to all elements with a data-post-id attribute
// and listen for elements with a data-meow-button attribute with value 'create'
// to fire a submit event
$('[data-post-id]').on('submit', '[data-meow-button="create"]', function(event) {
  // omitted
});


// Add an event listener to all elements with a data-post-id attribute
// and listen for elements with a data-meow-button attribute with value 'delete'
// to fire a submit event
$('[data-post-id]').on('submit', '[data-meow-button="delete"]', function(event) {
  // omitted
});
```

Hurray! The `alert` is now triggered by all of the different "Remove Meow" buttons.

### Replacing the "Remove Meow" button with "Meow" button when pressed

This step can be completed by finishing the `success` handler. The `success` handler here is almost exactly the same as when we replaced the "Meow" button with the "Remove Meow" button. The main difference is that we need to use the parent element that has the `Post`s `id` as a data attribute in order to assemble the `action` URL for the `form`. We can use [jQuery's .closest() function](http://api.jquery.com/closest/) to find the closest element with a `data-post-id` to do so.

```javascript
// app/assets/javascripts/catstagram.js

$('[data-post-id]').on('submit', '[data-meow-button="delete"]', function(event) {
  event.preventDefault();

  $form = $(event.currentTarget);

  $.ajax({
    type: "DELETE",
    url: $form.attr('action'),
    dataType: "json",
    success: function() {
      // Find the parent wrapper div so that we can use its data-post-id
      $post = $form.closest('[data-post-id]');

      // Create the String version of the form action
      action = '/posts/' + $post.data('post-id') + '/meows';

      // Create the new form for creating a Meow
      $newForm = $('<form>').attr({
        action: action,
        method: 'post',
        'data-meow-button': 'create'
      });

      // Create the new submit input
      $meowButton = $('<input>').attr({type: 'submit', value: 'Meow'});

      // Append the new submit input to the new form
      $newForm.append($meowButton);

      // Replace the old create form with the new remove form
      $form.replaceWith($newForm);
    }
  });
});
```

Your "Meow" and "Remove Meow" buttons should now be toggling and submitting asynchronously.

### Challenge

Make sure that you have followed through the previous section before continuing.

We've got the "Meow" and "Remove Meow" buttons submitting asynchronously and toggling back and forth but the "Meows" count doesn't still doesn't update until we refresh the page.

Your challenge is to modify the existing Javascript in `app/assets/javascripts/catstagram.js` to cause the "Meows" count to also update to reflect the correct amount of meows when the "Meow" and "Remove Meow" buttons are clicked on. Make sure that the plurality of "Meows" still matches the
meows count.

*Hint: You'll probably want to add another data attribute to the element responsible for displaying the "Meows" count.*
