Hangman is a word-guessing game. A word is chosen at random from a word bank that the player has to guess. The player is shown the number of characters in the word but they remain masked until the player guesses that letter. The player has a limited number of chances to guess the correct letters.

Each round the player can either guess a single letter or try to guess the entire word. If the player guesses the word correctly, they win the game. If the player attempts to guess the word and fails, they lose the game.

If the player guesses a letter and the letter is included in the word, the letter is unmasked for all occurrences in the word. If the letter is not included in the word, the number of chances is decremented by one. If the number of chances reaches zero, the player loses the game. If the player has already guessed a letter, the number of chances is not decremented.

## Requirements

* The hidden word only includes letters (no numbers, symbols, or whitespace).
* The hidden word should be randomly selected from a word bank.
* Each round the word is displayed with guessed letters revealed and hidden letters shown as underscores (e.g. `Word: __mm_t`).
* Each round display the number of chances remaining. Display `Chances remaining: CHANCES` where CHANCES is an integer.
* Each round, the player is prompted for input.
* The player's input should appear on the same line (no newline after the prompt).
* When a player enters a single character, it guesses a letter.
* When a player enters more than a single character, it guesses the word.
* If the guessed letter is within the word, those letters are unveiled.
* Display the number of times the letter is found when it is present.
* If the guessed letter is not within the word, subtract one from the chances remaining.
* The user is alerted if the guess is not found.
* If the guessed letter was already submitted, do not decrement the chances remaining.
* Display an error message if the letter was already guessed.
* If the guessed word matches the hidden word, the player wins the game.
* Output a congratulatory message if the guess was correct.
* If the guessed word does not match the hidden word, the player loses the game.
* Output an apologetic message if the guess was incorrect.
* The game ends when the number of chances remaining reaches zero.
* The user is alerted that they have run out of guesses.

## Sample Output

Here is what a sample run of the game should look like:

```no-highlight
$ ./hangman.rb
Welcome to Hangman!

Word: ______
Chances remaining: 8
Guess a single letter (a-z) or the entire word: j

Sorry, no j's found.

Word: ______
Chances remaining: 7
Guess a single letter (a-z) or the entire word: s

Sorry, no s's found.

Word: ______
Chances remaining: 6
Guess a single letter (a-z) or the entire word: m

Found 2 occurrence(s) of the character m.

Word: __mm__
Chances remaining: 6
Guess a single letter (a-z) or the entire word: t

Found 1 occurrence(s) of the character t.

Word: __mm_t
Chances remaining: 6
Guess a single letter (a-z) or the entire word: a

Sorry, no a's found.

Word: __mm_t
Chances remaining: 5
Guess a single letter (a-z) or the entire word: i

Found 1 occurrence(s) of the character i.

Word: __mmit
Chances remaining: 5
Guess a single letter (a-z) or the entire word: commit

Congratulations, you've guessed the word!
```

On failure:

```no-highlight
Welcome to Hangman!

Word: ______
Chances remaining: 8
Guess a single letter (a-z) or the entire word: a

Found 1 occurrence(s) of the character a.

Word: ___a__
Chances remaining: 8
Guess a single letter (a-z) or the entire word: j

Sorry, no j's found.

Word: ___a__
Chances remaining: 7
Guess a single letter (a-z) or the entire word: l

Sorry, no l's found.

Word: ___a__
Chances remaining: 6
Guess a single letter (a-z) or the entire word: q

Sorry, no q's found.

Word: ___a__
Chances remaining: 5
Guess a single letter (a-z) or the entire word: w

Sorry, no w's found.

Word: ___a__
Chances remaining: 4
Guess a single letter (a-z) or the entire word: e

Found 2 occurrence(s) of the character e.

Word: _e_a_e
Chances remaining: 4
Guess a single letter (a-z) or the entire word: o

Sorry, no o's found.

Word: _e_a_e
Chances remaining: 3
Guess a single letter (a-z) or the entire word: p

Sorry, no p's found.

Word: _e_a_e
Chances remaining: 2
Guess a single letter (a-z) or the entire word: s

Found 1 occurrence(s) of the character s.

Word: _e_ase
Chances remaining: 2
Guess a single letter (a-z) or the entire word: m

Sorry, no m's found.

Word: _e_ase
Chances remaining: 1
Guess a single letter (a-z) or the entire word: n

Sorry, no n's found.
You're out of chances, better luck next time...
```

## Notes

* You can choose a random element from an array using the [`sample`][sample] method.
* You can check if one string is included in another string using [`include?`][include] (e.g. `"foo".include?("o") # true`).
* You can find the first location of one string within another using the [`index`][index] method (e.g. `"bar".index("r") # 2`).
* To find the subsequent locations of one string within another you can pass in the starting point to `index` (e.g. `"banana".index("a", 2) # 3`).

[sample]: http://ruby-doc.org/core-2.0/Array.html#method-i-sample
[include]: http://ruby-doc.org/core-2.0/String.html#method-i-include-3F
[index]: http://ruby-doc.org/core-2.0/String.html#method-i-index
