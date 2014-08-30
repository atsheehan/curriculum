Create a game that picks a random number between 1 and some max value (e.g. 1000). The user should then be prompted to guess the number. If the user guesses correctly, they win the game and the program ends. If the guess is incorrect, respond with either "Too high" or "Too low" and prompt for input again.

## Example Usage

Here is what a sample run of the game should look like:

```no-highlight
$ ruby game.rb
Guess a number between 1 and 1000: 500
Too high, try again.

Guess a number between 1 and 1000: 250
Too high, try again.

Guess a number between 1 and 1000: 125
Too high, try again.

Guess a number between 1 and 1000: 67
Too high, try again.

Guess a number between 1 and 1000: 33
Too low, try again.

Guess a number between 1 and 1000: 50
Too low, try again.

Guess a number between 1 and 1000: 57
Congratulations, you guessed the number!
```
