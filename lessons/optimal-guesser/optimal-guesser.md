If asked to guess the value of a hidden number between one and a billion, how many tries do you think it would take? Quite a few, unless we were given some form of feedback. If we know whether our guess is too high or too low we can find the hidden value in less than thirty guesses using the [Binary Search algorithm][binary_search].

### Instructions

Implement the `guess_number` method in **guess_number.rb** so that it returns the hidden value. The `guess_number` method receives the range that the hidden value is in (e.g. `min = 1` and `max = 1000000000` to start). You can call the `check` method to determine whether your guess is correct or not, but there is a limit to how many times you can use `check`. Try to think of the most optimal way to determine what the hidden number is using the least amount of guesses (refer to this [algorithm][binary_search] for suggestions).

Run the **solver.rb** file to check whether your implementation is correct. For an incorrect result you'll see the following:

```no-highlight
$ ruby solver.rb
Incorrect guess.
```

When your implementation is correct it should change to this:

```no-highlight
$ ruby solver.rb
Guessed correctly!
```

**Note: only change the code within the `guess_number` method: the `solver.rb` file should not be changed.**

### Learning Goals

Implement an [algorithm][binary_search] in Ruby using *conditional expressions*.

[binary_search]: http://en.wikipedia.org/wiki/Binary_search_algorithm
