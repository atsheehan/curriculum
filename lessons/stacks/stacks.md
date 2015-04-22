We throw the term stack around a lot in this industry. Software stacks refer to the set of technologies we use to get something done. A LAMP stack (Linux, Apache, MySQL, PHP/Python) is a set of software that serves up webpages. The Rails stack consists of ActiveRecord, ActionController, ActionView, RSpec, and everything else in your Gemfile.

Forget all of that for the moment. We are going to talk about the **Stack Data Structure**, which you have been using all this time, but might not be aware of it.

### Learning Goals

* Learn about the stack data structure
* Implement a stack in Ruby
* Use a stack to solve the problem of matching brackets in source code

### The Stack

Imagine you are at the local Indian restaurant for lunch. They are serving lunch buffet style. "Awesome," you say to yourself, "I don't have to choose between Palak Paneer and Tandoori Chicken." As you queue up, you notice the busboy `push` a stack of plates into the spring-loaded plate holder. Oh, what a sad state of affairs to be the plate at the bottom. You wait all day, supporting all the other plates, but rarely ever get to be put into use. You don't ponder too long about the fate of that plate since the queue is moving along. You take a `peek` at the top plate to see that it's clean,`pop` it off the top, serve up some tasty curry and jasmine rice for yourself, and you're on your way...

Tucked away into this (poor) short story of going out for lunch are the methods that are provided by a Stack. We `push` items onto a stack much like the busboy loads plates onto the serving cart. We can take `peek` at the item at the top of the stack. We can remove, or `pop`, the top-most item. Exceeding the capacity of the serving cart by pushing too many plates onto the stack would cause the plates to topple and fall on the floor (Stack Overflow). Trying to pop a plate from an empty serving cart would leave you in a state of disappointment (Stack Underflow).

Not counting the stack of plates at your local Indian place, stacks are used to solve a number of Computer Science problems:

* storing the return address from a function call
* maintaining a list of operations for the `undo` action
* parsing syntax
* implementing search algorithms, specifically Depth-First Search

### Implementing a Stack

Before proceeding, grab the Stack code [here](https://github.com/LaunchAcademy/stack_assignment).

Based on what we have learned about stacks, we know a few things about this `Abstract Data Type`. It has a set of operations:

* push
* pop
* peek
* empty?

It also stores objects. We have dealt with this problem of storing objects before. For the sake of simplicity, let's use an array.

We have **state** and we have **behavior**. It sounds like we have the ingredients of an object:

```
class Stack
  def initialize
    @contents = []
    @index = -1
  end

  # ...

end
```

`Stack.new` calls the `initialize` method, and creates an empty container for us to store objects, and sets the index of the top of the stack. A stack isn't much good without a way to put objects into it. Let's implement the `push` method.

```
  def push(item)
    @index += 1
    @contents[@index] = item
  end
```

The `push` method takes in an object to be pushed onto the stack, increments the index of the top of the stack, and then assigns that position in the array to the object. What if we want to see this object? Let's implement the `peek` method.

```
  def peek
    @contents[@index]
  end
```

Fairly simple, right? The `peek` method just returns the value that is at the top of the stack. Let's implement the `pop` method, which will "remove" and return the top-most object.

```
  def pop
    result = peek
    @index -= 1
    result
  end
```

The `pop` method is defined in terms of the `peek` method. Why reinvent the wheel. `peek` already gives us the top-most item, so we assign that to a variable called `result`. The next step is to decrement the index of the top-most item. Then, we return the `result`.

Notice that we didn't actually remove an item from the array, we only changed the `@index` variable to the index below the top-most item. From an external standpoint, the implementation doesn't matter, we only have access to what is considered the top-most item. For example if we ran the following code, the numbers 1, 2, and 3 would still exist in the `@contents` variable, but we would have no way to access them from outside of the Stack class:

```
stack = Stack.new
stack.push(1)
stack.push(2)
stack.push(3)
stack.pop  # => 3
stack.pop  # => 2
stack.pop  # => 1
```

Internally, we have some garbage data to take care of. For this assignment, we won't worry about it, but, as Software Developers, we have to consider the ramifications of our code and how it behaves.

Here is the entire class as we have built it:

```
class Stack
  def initialize
    @contents = []
    @index = 0
  end

  def push(item)
    @index += 1
    @contents[@index] = item
  end

  def peek
    @contents[@index]
  end

  def pop
    result = peek
    @index -= 1
    result
  end
end

```

We have a working implementation of a Stack! However, what happens if we `pop` from an empty stack?

```
stack = Stack.new
stack.pop # => nil
# also @index = -2
```

We should not be able to do this. If we try to `push` to the stack now, we get an `IndexError`. Our `pop` method needs some improvement.

```
class StackUnderflow < StandardError
end

class Stack
  # ...

  def pop
    raise StackUnderflow if empty?
    result = peek
    @index -= 1
    result
  end

  def empty?
    @index == -1
  end
```

We have implemented a **guard clause** here to check if the stack is empty, and, if it is, raise an exception. In order to handle the case of Stack Overflow, we need to set a limit on the size of the stack on object creation, define the StackOverflow class, and then `raise StackOverflow` when a `push` would hit the size limit. This exercise is left to the reader to complete before continuing on with the assignment. (**Hint:** Start with a test.)

### Using the Stack

Ok. Now, we have a super-awesome Stack class that we built ourselves. What can we do with it besides simulating a stack of plates?

One of the problems that your editor (and the Ruby interpreter) sovles for you is checking that brackets match up in your source code. Ever wonder how that works? You guessed it... Stacks!

Your editor analyses your code, character by character. When it sees an opening bracket, it pushes it onto the stack. When it encounters closing bracket, if that bracket matches what's on top of the stack, it can pop it off. If it doesn't match, then we have a problem.

### Challenge

Write a Ruby class to solve the problem of matching brackets. It should return `true` if all the brackets match in a given input. It should return `false` if not. Your class should support matching `(, ), [, ],` and `{, }`.

### Noncore Challenge

Create `line` and `character` methods on your class that return the line and character number of the offending bracket(s) when `valid?` returns false.

### Noncore Challenge

Remeber how we said that we shouldn't worry about the garbage data that persists when we `pop` an item off of our Stack class? Well, now that we have been using our Stack class for larger projects, its tendency to hog memory has become an issue. How can we address this problem? What changes would you need to make to the Stack class in order for it to release garbage data, but still be performant?

### Resources

* [stack_assignment on github](https://github.com/LaunchAcademy/stack_assignment)
* [Stack (abstract data type)](http://en.wikipedia.org/wiki/Stack_(abstract_data_type))
* [Stack Overflow](http://en.wikipedia.org/wiki/Stack_overflow)
* [Abstract Data Type](http://en.wikipedia.org/wiki/Abstract_data_type)

### Why This is Important

#### Adding to Your Toolbelt

Stacks have been used to solve all sorts of problems in our field. Whenever you need to perform operations in a "Last In, First Out" (LIFO) manner, a stack is the right tool for the job.

#### Stacks Solve Problems

The Stack is the key tool used in performing a [Depth-First Search](http://en.wikipedia.org/wiki/Depth-first_search). A Stack can be used for interpreting and maintaining the order of operations when [evaulating a mathematical statement](http://en.wikipedia.org/wiki/Polish_notation).
