### Instructions

Build an implementation of "Guess The Number" using the `alert` and `prompt` functions of JavaScript.

#### Setup

We'll need an HTML page and a JavaScript source file to create our game.  You should see these files in the `lib/` directory.

Our HTML just needs enough structure to load our JavaScript source file.  It should look like this:

```HTML
<!DOCTYPE html>
<html>
  <head>
  <title>Guess the Number</title>
  </head>

  <body>
    <script src="guess_the_number.js"></script>
  </body>
</html>
```

This HTML will load the `guess_the_number.js` file when it starts up. To verify it works, add the following to `guess_the_number.js`:

```javascript
alert("does this work?");
```

Test it out by running:

```no-highlight
$ open lib/index.html
```

If you receive a popup, everything is hooked up correctly.

Let's open up the developer console in Chrome using `ALT + COMMAND + J`. Being the malicious JavaScript developers that we are, let's make some pop ups. Type in `alert("You've won an iPad");` into the Chrome developer console and hit enter. The alert should pop up.

Now let's be a little bit more malicious. Paste the following code into the console:

```javascript
for (var i = 0; i < 10; i++) {
  alert("You've won an iPad");
}
```

You can see how an evil JavaScript programmer could abuse this code. Alert boxes aren't limited to just accepting string values. We can also pass in a variable:

```javascript
var name = 'dogecoin';
alert(name + ' is going to the moon');
```

JavaScript also gives us a prompt function that allows us to get user input:

```javascript
prompt('How much wow?');
```

This will return a string value (in the same way that `gets` does in Ruby). Just as in Ruby, we can assign this value to a variable:

```javascript
var wow = prompt('How much wow?');
```

Now we can retrieve the value for `wow` by typing `wow` into the console, just like we could retrieve the value for a Ruby variable inside irb or pry.

So now let's put alert and prompt together.

```javascript
var name = prompt("What is your name?");
alert("Your name is "+ name);
```

Let's throw in a sprinkle of conditional logic inside of here as well:

```javascript
var spammer = prompt("Type in a name to find out if they are a spammer or not");
if (spammer.toLowerCase() === 'adam') {
  alert(spammer + ' is definitely a spammer');
} else {
  alert(spammer + ' is not a spammer');
}
```

Now you're equipped to tackle the guess the number game. We'll be writing our code inside of `lib/guess_the_number.js`. When you open up `lib/index.html` inside of a web browser it will run the code that is located inside of this file. Your program should do the following:

* Generate a random number
* Get the user's name
* Ask the user to enter a number
* If the number equals the random number let the user know that they've won, other wise let them know that they lost
