In this article we'll look at **linked lists**, a very basic data structure, and compare its structure and performance to **dynamic arrays** as implemented by the `Array` class.

### Learning Goals

* Understand how dynamic arrays store their elements
* Understand how linked lists store their elements
* Understand the tradeoffs between the two data structures

### Dynamic Arrays

When solving a problem one very important factor to keep in mind is what information we'll be working with. Not only do we need to think about the kind of information but also how we plan on using it.

We store and interact with information in our programs as **data**. The way that we structure our data varies depending on how we plan to use it. Will we primarily be reading or writing data? Do we need to insert data in arbitrary positions or can we just keep appending to the end? Does this data need to be kept sorted in any particular order? Questions like these and others will often dictate the **data structures** we use in our programs.

Let's take a look at a more familiar data structure. [Dynamic arrays][dynamic_arrays] are available in Ruby through the `Array` class. A dynamic array stores a list of elements consecutively in memory and will expand as needed to handle new elements. Consider this snippet of code:

```ruby
numbers = [8, 2, 3, 7]
```

This array might look something like the following in memory:

![Array Structure](https://s3.amazonaws.com/hal-assets.launchacademy.com/data-structures/array_structure.png)

Notice how the elements of the array form one consecutive chain. This allows us to find individual elements very quickly. If we want to access the third element, we find the address for the beginning of the array and then move over two spaces (`numbers[2]`). For the fourth element, we move over three spaces from the beginning (`numbers[3]`). The first element can be found at the start of the array so we don't need to move over any spaces (`numbers[0]`). We can find the position of any element in an array simply by starting at the beginning and adding an offset, an operation which runs in _constant time_ (or _O(1)_).

So we can access random elements in an array very quickly, but how does it perform when adding new elements? If we insert at the end of the array this isn't really a problem since we can grow the array as needed, but what about inserting an element somewhere in the middle? Consider the following snippet:

```ruby
numbers = [8, 2, 3, 7]
numbers.insert(1, 5)
# => [8, 5, 2, 3, 7]
```

This will insert the new value _5_ in the second element of the array. But to preserve the order of the existing elements, everything else had to be shifted to the right by one. Since there were three elements after the second one we have to perform three shifts just to make space for one new element. If our array was 1000 elements long and we inserted a value into the second position, we'd have to shift 999 elements one to the right. Because the number of elements we have to shift depends directly on the size of the array the insert operation runs in _O(n)_ time.

![Inserting an element in an array](https://s3.amazonaws.com/hal-assets.launchacademy.com/data-structures/array_insert.png)

### Linked Lists

If our problem is heavily dependent on inserting and deleting within a list of elements we may want to consider using a different data structure than the dynamic array. [Linked lists][linked_lists] are ordered collections of nodes that store two pieces of data: the value of the node as well as the next node in the collection.

By storing the position of the next node we can iterate through the entire list by repeatedly grabbing the next node in the chain. Since each node has a reference to its neighbor, we don't need to keep the nodes adjacent to each other in memory. If we had a linked list with four elements it might look something like the following:

![Linked List Structure](https://s3.amazonaws.com/hal-assets.launchacademy.com/data-structures/linked_list_structure.png)

This gives us a bit more freedom about where to store our nodes but it does come at a cost: if we only store the location of the first node, how do we access random elements from the list? For example, if we wanted to see what the value the fourth node contains, we'd have to start at the beginning, jump to the second node, then the third node, and finally end up at the fourth. If our list was 1000 nodes long, we'd have to make 1000 jumps to get to the last node. Because the number of jumps we have to make is dependent on the size of the list, random access to individual elements runs in _O(n)_ time.

One benefit of linked lists is that when we are inserting or deleting nodes within the list, we only need to update the pointer to the next node rather than shifting around a whole bunch of elements. For example, to insert the value _5_ in the second position (e.g. `insert(1, 5)`), we just have to change two links in the chain as shown in the following:

![Inserting a node in a linked list](https://s3.amazonaws.com/hal-assets.launchacademy.com/data-structures/linked_list_insert.png)

The same process is used for deleting nodes: removing the node from the chain only requires us to update one pointer. The only catch is that we need to find the spot to insert or delete the node (which takes _O(n)_). If we're adding nodes to the front of the list it will run in _O(1)_ time but for other inserts it will take the time to search for the spot plus the insert time (_O(n)_ + _O(1)_). If we're keeping nodes in sorted order and will be frequently insert them in arbitrary positions (e.g. a database index), a better data structure might be a [binary search tree][binary_search_tree].

### Linked Lists In Ruby

Ruby does not provide a linked list implementation by default but we could create our own. Looking at the lists above, we can break down our data structure into individual nodes and the list itself. The node only needs to know the value that it contains as well as what the next node in the chain is:

```ruby
class Node
 attr_accessor :data, :next

 def initialize(data, next_node)
    self.data = data
    self.next = next_node
  end
end
```

Here we're using `attr_accessor` to store these two attributes. The other class we'll need is the list itself which just needs to store a reference to the head node as well as a few methods for adding new nodes and iterating over them:

```ruby
class LinkedList
  def initialize
    @head = nil
  end

  def each
    node = @head

    while !node.nil?
      yield(node.data)
      node = node.next
    end
  end

  def prepend(value)
    @head = Node.new(value, @head)
  end

  class Node
    attr_accessor :data, :next

    def initialize(data, next_node)
      self.data = data
      self.next = next_node
    end
  end
end
```

Here we've nested the `Node` class within `LinkedList` since it's more of an implementation detail. We don't expect the user to interact with nodes individually, they only care about the value in the node. There's also methods for adding a new node to the front (`prepend`) and iterating over the entire list (`each`). Let's see an example of this in action:

```ruby
> list = LinkedList.new
> list.prepend(3)
> list.prepend(2)
> list.prepend(1)
> list.each { |val| puts val }
1
2
3
```

As an exercise, try implementing additional methods on the `LinkedList` class to support accessing individual elements, inserting values in arbitrary locations, or removing nodes:

```ruby
class LinkedList
  def [](index)
    # Code for accessing an individual element...
  end

  def insert(index, value)
    # Code for inserting a node...
  end

  def delete_at(index)
    # Code for removing a node...
  end
end
```

### Resources

* [Wikipedia: Dynamic Arrays][dynamic_arrays]
* [Wikipedia: Linked Lists][linked_lists]
* [Wikipedia: Linked Lists vs Dynamic Arrays][linked_list_vs_dynamic_array]
* [Wikipedia: Variations of Linked Lists][linked_list_variations]

[dynamic_arrays]: http://en.wikipedia.org/wiki/Dynamic_array
[linked_lists]: http://en.wikipedia.org/wiki/Linked_list
[binary_search_tree]: http://en.wikipedia.org/wiki/Binary_search_tree
[linked_list_vs_dynamic_array]: http://en.wikipedia.org/wiki/Linked_list#Tradeoffs
[linked_list_variations]: [http://en.wikipedia.org/wiki/Linked_list#Basic_concepts_and_nomenclature]
