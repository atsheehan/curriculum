In this assignment, you will be implementing a [linked list](linked-list-lesson) using Ruby classes. Use the tests to guide your development!

### Description

You should create two Ruby classes: `LinkedList` and `Node`.

`Node`s are the building blocks that a LinkedList is able to iterate through. Each `node` object should store two things: a piece of info (such as one "name", if we're looking at a linked list of names), and the subsequent node. In this way, each node remembers the next node in the list, meaning we're able to step through each one by turn.

The `LinkedList` class should store a reference to the **first node** in the list, and should be capable of stepping through the list of nodes and editing the data. Here is an example of how a LinkedList should be initialized:

```ruby
names = LinkedList.new
names.prepend("Adam")
names.prepend("Christina")
names.prepend("Vikram")
```

Here are the methods the LinkedList should support:

* `#prepend` -- demonstrated above. Takes in a value, and inserts a node of that value as the first item in the LinkedList.

* `#each` -- takes in a block using `yield`, performs that block on each node in the LinkedList  
```ruby
names.each do |name|
  puts name
end
```
* `#to_s` -- returns out a nicely-formatted string with each of the nodes listed in order (first to last)  
```ruby
names.to_s
# => LinkedList("Vikram", "Christina", "Adam")
```

* `#[]` -- supports indexing, such as on arrays. (Should take in an index between the brackets and return the node at that index.) If the index is out of range of the LinkedList, this should return `nil`.
```ruby
names[1]
# => "Christina"
```

* `#insert` -- takes in an index and a value, and inserts a node with the given value at the given index.
```ruby
names.insert(2, "Spencer")
# => LinkedList("Vikram", "Christina", "Spencer", "Adam")
```

* `#remove` -- takes in an index, and removes the node at the given index.
```ruby
names.remove(3)
# => LinkedList("Vikram", "Christina", "Spencer")
```

### Instructions
Before your start writing any code, run the test suite using `rspec spec`! Use the tests to guide your development by tackling each test one by one. Get the first test to pass before moving onto the second. Try to do the simplest thing that works, while still keeping in mind the general goals of your project!

### Tips
* Don't store nodes in an array! The LinkedList class should only remember the *first* node, all others should be accessed through alternate means.
* For defining each, consider using a [yield](http://rubymonk.com/learning/books/4-ruby-primer-ascent/chapters/18-blocks/lessons/54-yield) (check out the second code example on this page). `each` should allow a block of code to be called on each item of the LinkedList - so think about how to iterate through the list and call a given block of code on each item.
* For indexing, remember that `names[0]` is the same thing as calling `names.[](0)` or `names.[] 0`. `[]` is just the name of a method that takes in one argument (an integer). Ruby just happens to allow us to call this method in a prettier way by putting the integer between the brackets (which is the way you're used to seeing it!). This means that for defining the method, you can say something like `def [](index)`
* If you're having trouble visualizing the LinkedList, try drawing out the list with the connections between each node. Sketch out what should happen to those connections when a node is added or deleted.
* To focus your energy on just one test file, you can run `rspec spec/node_spec.rb` or `rqpec spec/linked_list_spec.rb` to run just one file's tests or the other. Also feel free to temporarily comment out certain tests in a file if you'd rather just focus on a few. 

### Additional Challenge

As an extra optional challenge, modify the class to allow items to be entered during the intialization of the object.

```ruby
# Advanced - allow for entries in the constructor
names = LinkedList.new("Vikram", "Christina", "Spencer", "Omid")
```
