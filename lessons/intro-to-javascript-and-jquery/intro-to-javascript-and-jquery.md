JavaScript is a core technology of the web, often used to add interactivity to web pages. In this article we provide a brief overview of JavaScript as well as jQuery, a popular JavaScript library that simplifies many common operations.

### Learning Goals

* Understand why JavaScript is used and what role is plays.
* Learn how to include JavaScript in a web page.
* Learn the basic syntax and operations of JavaScript.
* Use jQuery to query and manipulate portions of a web page.

### What is JavaScript?

Most web pages consist of three core technologies: HTML for content and semantic markup, CSS for presentation, and JavaScript for interactivity. When visiting a web page, modern browsers are able to combine these three technologies to provide an integrated user experience.

Unlike HTML and CSS which are languages used to *describe* content, JavaScript is a **programming language** that can be run in the context of a web page. JavaScript has access to something called the **Document Object Model (DOM)** that lets us write code to insert, modify, and remove parts of an HTML page as well as listen for user events such as clicking on a button or scrolling through a page.

Why can't we use something like Ruby to run code on our web pages? What makes JavaScript unique is that modern web browsers come pre-packaged with a JavaScript interpreter. Ruby (or any other programming language) is acceptable on the server since we can install the Ruby interpreter and any other software we need, but if we tried sending Ruby code in a web page a browser would not know how to run it. The fact that every user can run JavaScript makes the web an extremely popular option for deploying new applications that will reach the widest audience.

### Adding JavaScript to a Web Page

HTML can be viewed as defining the core structure of a web page. For a browser to run any JavaScript we provide, it first needs to load the HTML to define the context in which our code will run.

JavaScript is included on a web page via the `<script>` tag. There are two ways to use this tag:

* Embedding JavaScript directly in the HTML by writing code between the start and end `<script>` tags:

```HTML
<script>
alert("This is JavaScript code!");
</script>
```

* Referencing an external file containing the JavaScript source:

```HTML
<script src="my_javascript.js"></script>
```

For anything but small snippets of code, prefer loading JavaScript by referencing external files. This can often improve page load speed and reduce network bandwidth by utilizing something called **caching** which will avoid repeatedly downloading the same file on subsequent requests.

Within the HTML, it is customary to place any `<script>` tags within the `<head>` element of a page if they should be loaded _before_ the page has been fully rendered (e.g. any JavaScript used to change the appearance of certain elements before they are initially displayed). For all other JavaScript, they should be placed near the end of the page before the closing `</body>` tag so that the page is fully loaded and initialized before they are run.

Here is an [example layout](https://developer.mozilla.org/en-US/docs/Web/Guide/HTML/Tips_for_authoring_fast-loading_HTML_pages#Example_page_structure) for loading JavaScript within a page:

```HTML
<html>
  <head>
    <meta charset="utf-8">
    <title>Blah Blah</title>
    <!-- load any JavaScript needed to initially render the page -->
    <script src="any_js_used_for_rendering_page.js"></script>
  </head>
  <body>
    <!-- contents of the web page go here -->

    <!-- load all other JavaScript once the page has been loaded -->
    <script src="all_other_js.js"></script>
  </body>
</html>
```

### JavaScript Crash Course

Unlike Ruby which provides an interpreter to run the source code directly, JavaScript is often run in the context of a web page (alternatively, you can use something like **Node.js** to run JavaScript without a browser).

To run any of the JavaScript snippets within this section, create two files in a directory: _index.html_ which will contain a minimal HTML context and _sample.js_ which will contain any code you want to run. Add the following HTML to the _index.html_ file:

```HTML
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title>JavaScript sample</title>
  </head>

  <body>
    <script src="sample.js"></script>
  </body>
</html>
```

This creates a blank HTML page with a `<script>` tag to load a separate JavaScript file. Within the _sample.js_ file you can test out any of the JavaScript snippets below:

```JavaScript
// Test out any JavaScript snippets in here. Use the `console.log` function
// to print to the web development console.
```

Most modern browsers come with a suite of built-in web development tools that let you view the state of a web page and run or debug HTML, CSS, or JavaScript. In particular, the **console** often lets you view the output of any JavaScript code as well as run arbitary statements, similar to _irb_ for Ruby. To open the Web Development Console, press `Ctrl` + `Shift` + `K` in Firefox (or `Cmd` + `Shift` + `K` for Mac) or `Ctrl` + `Shift` + `J` in Chrome (or `Cmd` + `Option` + `J` for Mac).

Here we'll briefly highlight some JavaScript features and how they compare to Ruby. Try running the example code within the _sample.js_ file and verify the output in your browser's web console.

#### Variables

In Ruby, you can create a new variable by assigning to it:

```ruby
a = 1
b = 2

c = a + b
puts "The sum of #{a} and #{b} is #{c}"
```

In JavaScript, use the **var** keyword to define a new variable in the current scope:

```JavaScript
var a = 1;
var b = 2;

var c = a + b;
console.log("The sum of " + a + " and " + b + " is " + c);
```

It is possible to leave off the _var_ keyword for a new variable but it places it in the _global scope_ which we want to avoid when possible.

#### Conditionals

In Ruby, you can choose multiple paths using an `if..else` statement:

```ruby
if age >= 21
  beverage = "Gin & Tonic"
else
  beverage = "Shirley Temple"
end
```

In JavaScript, parentheses are required around the conditional expression and brackets are used to delimit the blocks of code to run:

```JavaScript
if (age >= 21) {
  var beverage = "Gin & Tonic";
} else {
  var beverage = "Shirley Temple";
}
```

JavaScript also supports **while** and **for** statements for looping (which we'll discuss shortly in the context of Arrays).

#### Data Types

JavaScript defines several primitive data types similar to Ruby. One difference in JavaScript is that there is only a single **Number** data type: there is no distinction between integers and floats and you do not need to convert between them.

For example, dividing two integers in Ruby will truncate the remainder:

```ruby
quotient = 4 / 3
puts "The quotient of 4 / 3 is #{quotient}"
# => The quotient of 4 / 3 is 1
```

JavaScript will handle converting to a Float automatically:

```JavaScript
var quotient = 4 / 3;
console.log("The quotient of 4 / 3 is " + quotient);
// The quotient of 4 / 3 is 1.3333333333333333
```

#### Functions

In Ruby, we can encapsulate a chunk of code in a method and assign it a name:

```ruby
def add(a, b)
  a + b
end

sum = add(1, 2)
puts "The sum of 1 and 2 is #{sum}"
```

In JavaScript, we define **functions** instead:

```JavaScript
function add(a, b) {
  return a + b;
}

var sum = add(1, 2);
console.log("The sum of 1 and 2 is " + sum);
```

Unlike Ruby, a function needs to explicitly define the return value using the **return** keyword, even if it is the last expression of the function body.

#### Arrays

In Ruby, you can define an Array using the `[]` syntax and iterate over one using `each`:

```ruby
numbers = [3, 2, 6]

numbers.each do |number|
  puts number
end
```

In JavaScript, it is common to use the **forEach** method to iterate over an array:

```JavaScript
var numbers = [3, 2, 6];

numbers.forEach(function(number) {
  console.log(number);
});
```

The `forEach` method was introduced in a later version of JavaScript that is supported by most (but not all) browsers. It is also common to iterate over an array using the **for** loop that is supported in all browsers:

```JavaScript
var numbers = [3, 2, 6];

for (var i = 0; i < numbers.length; i++) {
  console.log(numbers[i]);
}
```

[More info on Arrays can be found here.](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array)

#### Associative Arrays

In Ruby, you can create an associative array (i.e. a key-value data structure) using the `Hash` class:

```ruby
person = { first_name: "Barry", last_name: "Zuckerkorn" }
puts "Name: #{person[:first_name]} #{person[:last_name]}"
```

In JavaScript, you can create an associative array using **objects**:

```JavaScript
var person = { first_name: "Barry", last_name: "Zuckerkorn" };
console.log("Name: " + person.first_name + " " + person.last_name);
```

Objects are defined using the same `{}` syntax as Hashes in Ruby. Objects can also contain methods making them more like objects in Ruby. [More info on working with objects can be found here.](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Working_with_Objects).

#### Semicolons

JavaScript does not _require_ semicolons at the end of every statement but it is recommended to include them. If semicolons are omitted, the JavaScript interpreter will insert them using a set of [rules in the standard](http://bclary.com/2004/11/07/#a-7.9.1). While this will work fine most of the time, it can also introduce subtle bugs if the interpreter is inserting semicolons in an unexpected place.

#### Debugging

There are two common strategies for debugging JavaScript:

* `console.log` is a function that is similar to `puts` in Ruby. It will print a given string to the web development console and doesn't affect the HTML on the page.

* `debugger` is a keyword in JavaScript that behaves similarly to `binding.pry` in Ruby (with the _pry_ gem). When the interpreter reaches the `debugger` keyword it will pause execution and allow you to inspect any variables or run arbitrary code at that point in the script. Some browsers will _ignore_ the `debugger` keyword unless the web developer console is already open.

### What is jQuery?

Now that we've had a brief tour of the language, let's look at **jQuery**, a powerful JavaScript library that provides functions for DOM manipulation tasks.

Although all modern browsers can run JavaScript, there are slight differences between how the browsers interpret certain standard JavaScript functions that make writing cross-browser applications difficult. jQuery handles and abstracts these per-browser quirks so that we can write the same code that will work among all of the modern browsers.

### Loading jQuery

To use jQuery on a web page, the library needs to be loaded just like any other JavaScript code. [Download](http://jquery.com/download/) the latest version of the compressed, production library (it should be a single JavaScript file) and place it in the same directory as the rest of your JavaScript files.

To include the file in your web page, add another `<script>` tag before any other JavaScript that relies on jQuery:

```HTML
<body>
  <!-- contents of the web page go here -->

  <!-- load jQuery first -->
  <script src="jquery-1.11.2.min.js"></script>
  <!-- now load the rest of the JavaScript that depends on jQuery -->
  <script src="my_code.js"></script>
</body>
```

### Using jQuery

jQuery provides the `jQuery` function to access DOM nodes via CSS selectors. For example, if we wanted to retrieve a list of all `<li>` elements on the page, we can use the `jQuery` function with the `li` CSS selector to target them:

```JavaScript
var listItems = jQuery("li");
```

Since the `jQuery` function is used so often, it is aliased to `$` as a shorthand:

```JavaScript
var listItems = $("li"); // Same function as jQuery("li")
```

Often we only want to target specific elements on a page rather than all elements of a certain type. For example, consider an HTML page that has two unordered list elements, one used for the site navigation and another used for a list of notifications:

```HTML
<h2>Navigation</h2>
<ul>
  <li><a href="/">Home</a></li>
  <li><a href="/contact">Contact Us</a></li>
  <li><a href="/sign_in">Sign In</a></li>
</ul>

<h2>Notifications:</h2>
<ul>
  <li>Your payment is overdue!</li>
</ul>
```

If we wanted to write some code that will add a new notification to the second list, we would have to find a CSS selector that targets the second `<ul>` element but not the first one.

A common solution is to assign **ids** or **classes** to elements so that our JavaScript code has a way to target specific parts of a page:

```HTML
<h2>Navigation</h2>
<ul id="nav">
  <li><a href="/">Home</a></li>
  <li><a href="/contact">Contact Us</a></li>
  <li><a href="/sign_in">Sign In</a></li>
</ul>

<h2>Notifications:</h2>
<ul id="notifications">
  <li>Your payment is overdue!</li>
</ul>
```

Now we can write some code that will target the notifications list and append a new list item:

```JavaScript
// The "#" symbol is used to target elements with a specific "id"
$("#notifications").append("<li>Second notice!</li>");
```

The `append` function will inject the specified string right before the closing tag of the targeted element, adding another `<li>` element to the list.

### Event Handlers

Often we want to run some code in response to a user action such as clicking a button. These actions are called **events** and we can write JavaScript **event handlers** that run in response to them.

To write an event handler, we need to specify what code we want to run when some event occurs and then attach it to the appropriate event handler. The way to specify the code is by passing a function into the event handler.

```JavaScript
function popupMessage() {
  alert("Hi, I'm annoying!");
}

$("a").on("click", popupMessage);
```

The `on` function will assign the `popupMessage` function to be run whenever an `<a>` tag is *clicked* (i.e. whenever a user clicks a link). Since it is so common to pass functions as arguments to event handlers, we can inline the code like so:

```JavaScript
$("a").on("click", function() { alert("Hi, I'm annoying!") });
```

The `function(...) { ... }` literal is known as an **anonymous function** and is commonly used in JavaScript for one-time use functions.

### In Summary

**JavaScript** is used to make web pages more interactive and its use has been increasing as more diverse and complex applications are moving to the web.

JavaScript has the ability to query and manipulate the **Document Object Model (DOM)** which provides an interface to the web pages HTML and user actions.

**jQuery** is a popular JavaScript library that provides a simplified and uniform interface for manipulating the DOM. JavaScript is often run in response to user actions via **event handlers** which are triggered by changes to the DOM.
