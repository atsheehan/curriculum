Let's re-create [Minesweeper][minesweeper] in Ruby! We'll use the [gosu][gosu] library to handle the graphics and input code. To represent our game we can define a new class called `Minefield` which manages the state of the world. In this challenge we provide the setup code and a bare-bones implementation of `Minefield` and you have to flesh it out to end up with a functional game.

## Setup

Install the `gosu` gem which handles the main game loop and provides methods for drawing to the screen and reading user input:

```no-highlight
$ gem install gosu
```

The `minesweeper.rb` file contains the code for setting up the game and drawing the minefield. To test the game, you can run the `minesweeper.rb` program:

```no-highlight
$ ruby minesweeper.rb
```

The game depends on the `Minefield` class defined in `minefield.rb`. This class is used to represent the state of the game. We've provided a barebones version that doesn't do much: you'll have to update the following methods so that they function correctly.

```ruby
# Return true if the cell been uncovered, false otherwise.
def cell_cleared?(row, col)
  false
end

# Uncover the given cell. If there are no adjacent mines to this cell
# it should also clear any adjacent cells as well. This is the action
# when the player clicks on the cell.
def clear(row, col)
end

# Check if any cells have been uncovered that also contained a mine. This is
# the condition used to see if the player has lost the game.
def any_mines_detonated?
  false
end

# Check if all cells that don't have mines have been uncovered. This is the
# condition used to see if the player has won the game.
def all_cells_cleared?
  false
end

# Returns the number of mines that are surrounding this cell (maximum of 8).
def adjacent_mines(row, col)
  0
end

# Returns true if the given cell contains a mine, false otherwise.
def contains_mine?(row, col)
  false
end
```

Once these methods have been implemented the game should run correctly.

[minesweeper]: http://en.wikipedia.org/wiki/Minesweeper_(video_game)
[gosu]: http://www.libgosu.org/
