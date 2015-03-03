## Contents
- How to use Classes in Ruby
- Construction and Instance Variables

## How to use Classes in Ruby

### Learning Objectives

* Model real world objects with _classes_
* Correlate _instances_ with nouns
* Correlate adjective with _instance variables_
* Create classes that have constructors
* Instantiate custom objects
* Use instance variables to persist constructor arguments
* Test for equality among instances of the same object

### Class creation basics

In Ruby, we have learned that everything is an object. _Objects_ are specific
instances of a particular classification of objects.

```ruby
my_list = Array.new
```

We can look at the above line of code and translate it to the spoken words
"Create a new array and call it `my_list`."

We've been using objects and this idea of metaphor all along without necessarily
being aware of it. Every value and variable we use points to an object in Ruby.
An **object** is simply a way of combining our _data_ with _code_ that operates
on that data. Consider the array `my_list`:

```no-highlight
my_list = Array.new
my_list.class
 => Array
```

#### Objects are proper nouns

Though we may not realize it, when we define an Array like this, we are creating
an instance of type `Array`. 

We can think of the specific Array `my_list` as a proper noun - a specific
instance of an Array, defined as an ordered list of items. This instance can be
different from other instances of the same Array object, like we demonstrate in
the code below.

```ruby
#Below, we create two instances of the Array class
my_list = [1, 2, 3, 4]
letters = ['a', 'b']

my_list == letters
=> false

my_list.class == letters.class
=> true
```

Though these two lists share the same class, we see that they are different
instances. They have unique traits that distinguish them from each other.

Every time we create a new instance, this instance gets it's own place in your
computer's memory.

```ruby
5.times { puts [].object_id }
```

Example output:

```no-highlight
70224947963540
70224947963460
70224947963380
70224947963320
70224947963260
```

As you can see, every instance is unique and special in its own right.

#### Classes are common nouns

Classes refer to what we would call in the spoken word, common nouns. These are
general objects. In the spoken word, we have a way to refer to a classification
of objects generally. We can say things like the examples below.

* "These cars are gas powered."
* "Cars are parked in the parking lot."
* "Cars have engines."
* "Cars are used to travel."

Though we're not talking about a specific car, we can make generalizations and
assumptions about cars. We can define what they do, how they function, and what
one might use them for without having to speak to a specific car.

In Ruby and other "object oriented" programming languages, we use **classes** in
the same way. We can describe general behaviors of types of objects and classify
them.

All objects have a type which is known as their **class**. An object's class
dictates how it stores its data and what methods are available to operate on
that data. In this assignment, we've worked with objects of class Array which
comes predefined in the Ruby core.

```ruby
my_list = ['a', 'b', 'c'] #we create a new array
another_list = [1, 2] #we create another new array

# though we have different instances of type Array, 
# they share common functionality

my_list.length
=> 3

another_list.length
=> 2

# We can also make assumptions about behavior
# when we group them together

[my_list, another_list].each do |list|
  list.push('another item')
end

my_list
=> ['a', 'b', 'c', 'another item']

another_list
=> [1, 2, 'another item']
```

The methods above are defined on both instances because they are both instances
of the `Array` class. Because we classify them in the spoken word as a "list of
items", they share common behaviors.

With the general concept of lists, you can always:

* create a new list
* add items to them
* determine how long the list is
* reorder the list's contents
* remove items from the list

With Array instances, you can also always perform those functions with Ruby syntax.

```ruby
my_list = []                   # create a new list
my_list.push('another item')   # add items to a list
my_list.length                 # determine how long the list is
my_list.shuffle                # reorder the list's contents
my_list.delete('another item') # remote items from the list
```

In ruby, classes are known as **constants**. While we learned that every
instance is special and unique, there is only one instance of a certain class,
and it does not change its place in memory.

```ruby
5.times { puts Array.object_id }
```

Example output:

```no-highlight
70224896758060
70224896758060
70224896758060
70224896758060
70224896758060
```

##### Class Naming Conventions

Notice how ruby follows a slightly different convention for naming classes than
it does for naming variables. Classes should always use _camelcase_: the first
letter of each word is capitalized with no underscores or spaces between words.
Stick to this convention unless you enjoy incurring the wrath of Ruby developers
everywhere.

#### Instance methods are verbs

When we create the instance `my_list`, we can take advantage of a series of
verbs that we can perform on all objects of type `Array`. In ruby, we define
these verbs as **instance methods**. These are verbs that our objects can
perform.

```ruby
my_list.push('another item')   # add items to a list
my_list.length                 # determine how long the list is
my_list.shuffle                # reorder the list's contents
my_list.delete('another item') # remove items from the list
```

Each line above invokes instance methods on the `my_list` instance. These are
functions we can call on all instances of type `Array`. In fact, these methods
are defined by the `Array` class. These are verbs that all of our objects of
`Array` class can perform.

```ruby
"boo".shuffle
```

The code above raises an error `NoMethodError: undefined method 'shuffle'`. This
is because the instance we're working with is of type `String`. Strings, by
definition, have a different set of verbs they can perform. Those instance
methods are defined by the class `String`.

Let's create our first custom class together.

```ruby
#class definition
class Car
  #constructor
  def initialize(paint_color)
    #instance variable assignment
    @color = paint_color
  end

  #instance method
  def color
    @color
  end

  #instance method
  def start
    puts "vroom vroom"
  end
end
```

Above, we've defined the class `Car`. Let's decompose this.

```ruby
class Car
end

Car.new
```

Above, this is the minimum code we need to start creating objects of type `Car`.
Try it and see what is returned when Car.new is invoked.

```ruby
class Car
  def initialize(paint_color)
    @color = paint_color
  end
end

Car.new('black')
```

Here, we introduce a **constructor**. We will talk about this in further detail
later, but this is what is called when `Car.new('black')` is invoked. To help
prove this, we could introduce a `puts` statement.

```ruby
class Car
  def initialize(paint_color)
    puts "constructor called"
    @color = paint_color
  end
end

Car.new('black')
```

Just like we can pass arguments to plain old methods, we can pass arguments to
instance methods. Here, we pass an argument to the constructor that represents
the color of the car that we want to create. In plain language, we would say
"create a new car that is black". This is important data we can use to describe
the instance we've just created. In object oriented programming, we use
**instance variables** 

#### Instance Variables are traits or adjectives

We can use **instance variables** to describe our instances. Like in the example
above, we assign the `@color` instance variable to the value that is supplied as
a parameter to the constructor. We can use this instance variable to describe
the traits of the instance we created.

```ruby
class Car
  #constructor
  def initialize(paint_color)
    #instance variable assignment
    @color = paint_color
  end

  #instance method
  def color
    @color
  end
end

dans_car = Car.new('black')
dans_car.color
=> 'black'

blue_car = Car.new('blue')
blue_car.color
=> 'blue'
```

Recall that methods return the last line that is evaluated inside it. In this
case, the instance method `color` returns the value of the instance variable
`@color`. The instance variable that is assigned in the constructor can be used
to describe the object we created.

If it helps, we can also think of the `Car` class as a car factory. Every
invocation of `Car.new` is like a new car being produced and driven off of the
factory floor. We call every car that gets produced from the `Car` class and
**instance** of a `Car`.

| Programming Concept| Real World Concept | Real World Example| Programming Example |
| ------------- |-------------| -----|-----|
| Object Instance | Proper Noun | Dan's Black Car| `dans_car = Car.new('black')` |
| Class | Common Noun |Car | `class Car; end;` |
| Instance Method |Verb | Dan's Black Car started |`Car.new('black').start` |
| Instance Variable | Adjective | Black | `@color = 'black'` |

### Class creation reasons

For a class to be justified in your design, you want it to both require
**state** and **behavior**. We define **state** with our metaphorical adjectives
or traits. In this review assignment, we will discuss how constructors and
instance variables allow us to maintain **state**. We can define the state of an
object based on it's characteristics. For example, we would say in the spoken
word:

* This car is black
* This car is Dan's
* This car has a 4-cylinder engine

For the life of the car object, unless some behavior alters its state, this
information will always be true. In this review assignment, we will discuss how
constructors and instance variables allow us to maintain **state**. We can
express a similar sense of **state** through the ruby programming language. 

```ruby
class Car
  def initialize(color, owner, cylinders)
    @color = color
    @owner = owner
    @cylinders = cylinders
  end
end

#create a Car instance that represents Dan's black 4-cylinder car
dans_car = Car.new('black', 'Dan', 4)

#create a Car instance that represents Mark's red 6-cylinder car
marks_car = Car.new('red', 'Mark', 6)
```

Unless the car exhibits a behavior where it can change ownership, be repainted,
or get a new engine, the characteristics of `dans_car` and `marks_car` will
always be the same.

Given a deck of cards, we could use custom objects to represent the cards in the
deck. Let's explore the creation of a `Card` object.

```
class Card
end

Card.new
```

When we call `Card.new`, we say that we are instantiating a new `Card` object.

In the context of traditional card games, a card has a number and a suit. We can
define a **constructor** that takes two arguments, the card's suit, and the
card's rank (numbers 1-10, Jack, Queen, King, Ace).

```ruby
class Card
  def initialize(rank, suit)
    puts "Create a new card: #{rank} of #{suit}"
  end
end

Card.new('♠', '10')
```

Above, through the use of custom objects, we're saying in the spoken word
"Create a new 10 of spades card."

Notice how the method invocation does not match the name of the method
definition. In ruby, a constructor is a special kind of method. In a class
context, a `new` invocation will always run the `initialize` method in a class.

The code example above serves us well in that it represents the idea of creating
a Card object for our blackjack program to use, but we must retain the data that
is supplied by the constructor for us to do some useful operations on the card.
In order to retain the information specific to our Card instance, we can use
**instance variables**

#### Instance Variables

Instance variables are variables we can use inside our classes to retain and
manipulate data specific to our instance. In the code example above, we think we
are creating a 10 of spades, but ruby has no way of knowing that without
retaining some of the information inside the instance. With instance variables,
we can improve our implementation below.

```ruby
class Card
  def initialize(rank, suit)
    @suit = suit
    @rank = rank
    puts "Create a new card: #{@rank} of #{@suit}"
  end
end

ten_of_spades = Card.new('10', '♠')
```

Here, we've introduced the instance variables `@suit` and `@rank`. For the life
of the `10_of_spades` object we created, `@suit` will always be `'♠'` and
`@rank` will always be `'10'`.

We've now created this concept of a playing card in our program, and using
instance variables, we can describe attributes of our specific instance.

Just like we can have optional parameters in our methods, we can have optional
parameters in our constructors. Try the code below.

```ruby
class Card
  def initialize(rank, suit = nil)
    if suit.nil?
      @suit = ['♠', '♣', '♥', '♦'].sample
    else
      @suit = suit
    end
    @rank = rank
    puts "Create a new card: #{@rank} of #{@suit}"
  end
end

5.times { Card.new('10') }
```

### Rules to Follow

Constructors, or in the context of ruby, the `initialize` method, are intended
to be the places we're objects are born. Use these methods to retain data
relevant to the objects you're creating.

Instance variables are what you can use in constructors and other instance
methods to retain and change information pertaining to a specific instance of an
object.
