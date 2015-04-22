Along with Stacks, **Queues** are another fundamental Data Structure that require our attention.

### Learning Goals

* Learn about the Queue data structure
* Implement a Queue in Ruby
* Use a Queue to solve the problem of performing tasks in a specific order.

### The Queue

A Queue, as you might already be familiar from queing up at the Post Office, is simply an ordered list of items (or people). You `enter` the queue from the end, and you `leave` the queue from the front. The other methods we would like to have are `peek`, which should show us what is at the front of the queue, and `empty?`, which tells us if there is anyone or anything left in line.

### Implementing a Queue

Before proceeding, grab the Queue project, [here](https://github.com/LaunchAcademy/queue_assignment).

For this assignment, you will implement a Queue class. The github repository contains a set of failing specs, and an empty Queue class. Make the `spec/queue_spec.rb` tests pass before proceeding.

### Using the Queue

Let's use the Queue to load in text data from a file, character by character. Once we have it loaded in, we can perform some analysis on it. If you need a text file, [here you go](http://textfiles.com/100/).

```
require_relative 'lib/queue'

buffer = Launch::Queue.new
File.open('paragraph.txt', 'r') do |file|
  f.each_char do |char|
    buffer.enter(char)
  end
end
```

Our Queue is now a **Buffer**! By loading character data into our Queue from a file, it is acting as a [Buffer](http://en.wikipedia.org/wiki/Data_buffer), storing our data for later use.

### Challenge

Now that you have your text file loaded into a buffer, let's do some processing on it. Write a method that performs a character count. The data structure it returns should be a Hash where each key is a letter, and the value is the number of occurances of that letter.

### Resources

* [queue_assignment on github](https://github.com/LaunchAcademy/queue_assignment)
* [Queue (abstract data type)](http://en.wikipedia.org/wiki/Queue_(abstract_data_type))
* [Abstract Data Type](http://en.wikipedia.org/wiki/Abstract_data_type)

### Why This is Important

Queues are used to implement data buffers. The [sidekiq](https://github.com/mperham/sidekiq) and [resque](https://github.com/resque/resque) libraries are implementations of queues that process jobs in a [first in, first out (FIFO)](http://en.wikipedia.org/wiki/FIFO) manner.
