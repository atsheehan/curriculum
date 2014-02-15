# Tic Tac Toe

## Instructions

Write a ruby program which determines if there is a winning combination
of `x` or `o` on a tic tac toe board.

INPUT SAMPLE:

```ruby
[['o', ' ', ' '],
 ['o', ' ', ' '],
 ['o', ' ', ' ']]

[['o', ' ', 'x'],
 ['x', 'x', 'o'],
 ['o', ' ', 'x']]
```

OUTPUT SAMPLE:

```ruby
true
false
```

## Hints

Get the horizontal test to pass first, then remove `skip` from the
vertical test and get it to pass.  Finally, solve the diagonal test
case.
