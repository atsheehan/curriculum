## Instance Methods

### Learning Objectives

* Define custom instance methods
* Utilize return values to create expressive programs
* Identify when to create class methods
* Identify three ways in which class methods can be declared

### How to define

In a previous assignment pertaining to defining getters and setters, we've already defined **instance methods** that change the **state** of our objects. In this review assignment, let's focus on **instance methods** that bring our objects to life through adding **behavior**.

Let's work with a new class of objects, the `RightTriangle`.

```ruby
class RightTriangle
  def initialize(leg_a_length, leg_b_length)
    @leg_a_length = leg_a_length
    @leg_b_length = leg_b_length
  end
end
```

Recall that we can calculate the length of our hypotenuse using the [Pythagorean theorem](http://en.wikipedia.org/wiki/Pythagorean_theorem). Let's define a behavior that returns the hypotenuse's length.

```ruby
class RightTriangle
  def initialize(leg_a_length, leg_b_length)
    @leg_a_length = leg_a_length
    @leg_b_length = leg_b_length
  end

  def hypotenuse_length
    Math.sqrt(@leg_a_length**2 + @leg_b_length**2)
  end
end

triangle = RightTriangle.new(3,4)
triangle.hypotenuse_length
# => 5.0
```

Here, we introduce the Ruby way of calculating an exponent. `@leg_a_length**2` is the same as the spoken word: "leg a length squared."

We also calculate a square root, using `Math.sqrt`.

The return value of the `hypotenuse_length` method reflects what Pythagorean theorem states: the length of the hypotenuse is the square root of the sum of each leg squared.

Here, we've added **behavior** that calculates the length of the hypotenuse. We use the **state** defined by the `@leg_a_length` and `@leg_b_length` instance variables. We take advantage of the ability to return values from our function to provide meaningful **behavior**.

#### Behaviors That Change State

Let's say we are writing a riveting application that simulates the use of educational office supplies. We have a `DryEraseMarker` object. For every character that we write on a white board, it uses 0.01% of the marker's ink.

```ruby
class Whiteboard
  attr_accessor :contents

  def initialize(contents = [])
    @contents = contents
  end
end

class DryEraseMarker
  attr_reader :color, :capacity
  def initialize(color)
    @color = color
    @capacity = 100
  end

  INK_USE_PER_CHARACTER = 0.01
  def write(contents, whiteboard)
    @capacity = @capacity - (INK_USE_PER_CHARACTER * contents.length)
    whiteboard.contents << contents
  end
end
```

Notice in the code above, we do not allow the developer to manually adjust or set the capacity. That's because, in our design, we don't want to manipulate the capacity of the marker unless something is written. The **behavior** that we define is that as the user of the marker writes on a whiteboard, the capacity of the marker diminishes.

Also observe that we've introduced a relationship between the `DryEraseMarker` instance and the `Whiteboard` instance. We say that the `DryEraseMarker` implementation is now **coupled** to the `Whiteboard` implementation, because the `DryEraseMarker` needs to know how to write on the whiteboard.

```ruby
whiteboard = Whiteboard.new
black_marker = DryEraseMarker.new('black')

black_marker.write('Hello Launchers', whiteboard)
black_marker.write('My name is Slim Shady', whiteboard)
```

Given the code above:

### Rules to Follow

#### Add Behavior to Your Objects With Instance Methods

Where instance variables describe the **state** of an object, instance methods describe the **behavior** of an object. We can define instance methods to make our objects take action.

#### Use Return Values to Provide Meaningful Output

We can use return values in our instance methods to meaningfully communicate behaviors between objects. Like we did in the `RightTriangle` example, returning a meaningful result provides the client of that method with data to work with.

## Class Methods

### How to define

#### When Are Class Methods Used?

When we define behavior that is not contextual to a specific object or instance,
we can define that behavior as a class method. Generally, we use class methods
when our design calls for some type of global behavior.

Let's continue with our car metaphor below.

```ruby
class Car
  def initialize(color, make, model)
    @color = color
    @make = make
    @model = model
  end

  def self.valid_makes
    [
      'Chevrolet',
      'Ford',
      'GMC',
      'Toyota',
      'Volkswagen'
    ]
  end
end

puts Car.valid_makes.inspect
```

In the above code example, we've created a list of valid makes that we can use
as a global collection of makes we can assign to our `Car` instances.

We could raise an error if we try to instantiate a `Car` object with an invalid make.

```ruby
class Car
  def initialize(color, make, model)
    @color = color
    if valid_make?(make)
      @make = make
    else
      puts "Invalid make #{make}"
    end
    @model = model
  end

  def valid_make?(make)
    self.class.valid_makes.include?(make)
  end

  def self.valid_makes
    [
      'Chevrolet',
      'Ford',
      'GMC',
      'Toyota',
      'Volkswagen'
    ]
  end
end
```

Here, we don't assign the `@make` instance variable if the parameter is not in the list of `valid_makes`.

Let's take a moment to study our instance method `valid_make?`.  Our call to
method `valid_makes` is interesting because we prefix the invocation with
`self.class.valid_makes`. `self` in this case refers to the instance itself,
because we are in the context of an instance method. We've learned previously
that every object instance in ruby has a method `class`. In this case,
`self.class` will return `Car`. We can use the code below to verify these
findings.

```ruby
class Car
  def initialize(color, make, model)
    @color = color
    if valid_make?(make)
      @make = make
    else
      puts "Invalid make #{make}"
    end
    @model = model
  end

  def valid_make?(make)
    puts "self: #{self.inspect}"
    puts "class: #{self.class.inspect}"
    self.class.valid_makes.include?(make)
  end

  def self.valid_makes
    [
      'Chevrolet',
      'Ford',
      'GMC',
      'Toyota',
      'Volkswagen'
    ]
  end
end

car = Car.new('black', 'Ford', 'Pinto')
car.valid_make?('Saturn')
# => false
# this also outputs:
# self: #<Car:0x007f9ca2014a50 @color="black", @make="Ford", @model="Pinto">
# class: Car
```

### Rules to Follow

#### Use Class Methods For Contextual, General Behavior And Configuration

Class methods provide an expressive way to define behavior pertinent to a classification of objects.
