JavaScript and jQuery can be used to create interactive web pages that can modify the page without having to communicate with a web server. In this challenge you'll create a game entirely on the client using a combination of HTML, CSS, and JavaScript.

### Instructions

Create a guessing game in the browser by modifying the *index.html*, *js/guess.js*, and *css/styles.css* files. To test out the game, open the *index.html* file in a web browser:

```no-highlight
$ firefox index.html
```

When the browser loads the page it should select a hidden number between 1 and 100. The user has to guess the hidden value by entering a number in an HTML form and submitting it. Upon submitting the number, the browser displays a new message indicating whether the guess was correct, too high, too low, or invalid (e.g. not a number).

In addition to the form for submitting a guess, the user should be able to reset the game by pressing a button which clears out any existing messages and generates a new hidden number.

The game should exist entirely on the client (i.e. there is no need for a web server).

### Sample Application

Here is an example of what the application may look like:

![Guess the Number](https://s3.amazonaws.com/hal-assets.launchacademy.com/guess-the-number-form/guess-the-number.png)

### Tips

* The `Math.random()` returns a random number greater than or equal to zero but less than one. To generate a random integer between 1 and 100, try scaling the random number along with the `Math.floor` function as described [here](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Math/random).
* When binding to the form submit event, use the [`preventDefault()` function](http://api.jquery.com/event.preventdefault/) to avoid refreshing the page.
* The [`parseInt` function](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/parseInt) can be used to convert a user inputted string to a number. If this function fails it returns `NaN` (not a number) which can be checked using the [`isNaN()` function](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/isNaN).
