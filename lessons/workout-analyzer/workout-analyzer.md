### Learning Goals

* Get more practice building Ruby classes.

### Instructions

Because you are a huge nerd and you like working out (let's pretend), you've decided to track all your workouts in the `workouts.csv` file. Now you want to write an object-oriented program that will run some analytics on your data.

Specifically, you want a program that when run will output the following summary given the data in the CSV:

Define a `Workout` class that encapsulates the necessary data and the methods that calculate this information.

Some hints:

* A workout should be categorized as a "cardio" workout if at least 50% of the exercises were cardio exercises. It is a "strength" workout if at least 50% of the exercises were strength exercises. Otherwise, it should be categorized as "other".
* "Duration" should add up the duration of all of the exercises in a given workout.
* For calories burned, assume the following:
  * cardio exercises burn 8 calories/min
  * strength exercises burn 5 calories/min
* You can use the [table_print gem](https://github.com/arches/table_print) to print out tables in your console.

### Setup

You'll want two files in your app: a file that defines the `Workout` class, called `workout.rb`, and a file that will load in the workout data from the CSV and output the workout summary when run in the terminal, called `workout_summary.rb`.  Save the following code in the `workout_summary.rb` file:

```ruby
require_relative 'workout'
require 'csv'

# create a hash of workout info from CSV
def load_workout_data(filename)
  workouts = []

  CSV.foreach(filename, headers: true, header_converters: :symbol, converters: :numeric) do |row|
    workout = workouts.find { |wo| wo.id == row[:workout_id] }

    if workout.nil?
      workout = Workout.new(date: row[:date])
      workouts << workout
    end

    exercise = {
      name: row[:exercise],
      category: row[:category],
      duration_in_min: row[:duration_in_min]
    }

    workout.exercises << exercise
  end

  workouts
end

# YOUR CODE HERE

```

In the `workout.rb` file, add the following code:

```ruby
class Workout
  # YOUR CODE HERE
end
```

### Extra Challenge

Create an `Exercise` class.  An exercise object should have the following attributes:

- `workout_id`
- `name`
- `category`
- `duration_in_min`

A `Workout` object should have an `@exercises` instance variable that is an array of `Exercise` objects.
