As with sorting algorithms, many search algorithms exists and which you use depends on the type and amount of information you have to work with. Given a list (with no duplicate values), one of the major factors affecting our choice of algorithms is whether the list is sorted or not.

In this article, we look at two common search algorithms, linear and binary, using both sorted and unsorted lists to determine efficient or lack thereof.

### Learning Goals

* Understand the impact of a linear search algorithm
* Implement an efficient binary search algorithm

### Linear Search

Given an unsorted list, we're tasked with finding the index or position of a specific value. The linear or sequential approach is to iterate over every element of the list, comparing the input given with the value at the current index in the loop. At best, we may find our answer in the first position. At worse we may have to iterate over the entire list to find that the input is  the last position of our list if present at all. Linear search is a classic O(n) complexity problem because as our list grows, it takes that much more time to complete the search.

Our algorithm steps for this linear search include:

* Iterate over every element in the list and determine if the value at each index is the input to be found.
* When the input is found, we return the current index or position. If not found, continue the iteration until the entire list has been examined.

Let's implement it in Ruby:

```ruby
def linear_search(list_to_search, value_to_find)
  list_to_search.each_with_index do |current_value, current_index|
    return current_index if current_value == value_to_find
  end
end
```

Given a [list of unordered names](https://s3.amazonaws.com/hal-assets.launchacademy.com/searches/unordered_names.txt), we can make use of our `linear_search` method and get the following:

```ruby
names = IO.read('unordered_names.txt').split(',')
name_to_find = "James"
found_at = linear_search(names, name_to_find)

puts "Found '#{name_to_find}' at position #{found_at} in the list."

# Sample output
Found 'James' at position 119 in the list.
```

In the example above, we searched an unordered list but what impact would a sorted list have on our search performance? Let's benchmark both types of lists to see how our linear search performs.

```ruby
require 'benchmark'

def linear_search(list_to_search, value_to_find)
  list_to_search.each_with_index do |current_value, current_index|
    return current_index if current_value == value_to_find
  end
end

name_to_find = "James"

unordered_names = IO.read('unordered_names.txt').split(',')
ordered_names = unordered_names.sort

Benchmark.bm(30) do |x|
  x.report("Unordered List Search:") { linear_search(unordered_names, name_to_find) }
  x.report("Ordered List Search:") { linear_search(ordered_names, name_to_find) }
end
```

```no-highlight
                                user     system      total        real
Unordered List Search:      0.000000   0.000000   0.000000 (  0.000034)
Ordered List Search:        0.000000   0.000000   0.000000 (  0.000017)
```

It is clear that given the same input and a sorted list, the linear search performed better but there is still a fundamental problem with our approach. We're still iterating through each element of the array using O(n) complexity. To address the concern of the search taking longer as the list grows, we look at a more efficient algorithm for searching called a **binary search**.

### Binary Search

Given a sorted [list of names](https://s3.amazonaws.com/hal-assets.launchacademy.com/searches/ordered_names.txt) and asked to find a name beginning with the letter "M", you would might do what you'd normally do with a phone book for example, that is, open the book so you have roughly two halves and determining which half to examine next. You'd repeat this process until you narrowed down the quantity of names you have to go through by getting as close as possible to the target name. A **binary search** works in the same way and is said to operate with an O(log (n)) complexity as opposed to the less efficient linear search operating at O(n) complexity.

A binary search implementation in Ruby might look like so:

```ruby
def binary_search(list_to_search, value_to_find)
  low, high = 0, list_to_search.length
  middle = (low + high) / 2

  while (low <= high)
    middle = (low + high) / 2

    return list_to_search[middle] if list_to_search[middle] == value_to_find

    if list_to_search[middle] < value_to_find
      low = middle + 1 # search lower half
    else
      high = middle - 1 # search upper half
    end
  end

  nil # return nil if value wasn't found in list
end

ordered_names = IO.read('ordered_names.txt').split(',')
name_to_find = "Mark"

Benchmark.bm(30) do |x|
  x.report("Linear Ordered List Search:") { linear_search(ordered_names, name_to_find) }
  x.report("Binary Ordered List Search:") { binary_search(ordered_names, name_to_find) }
end
```

Running our search comparison a few time yields the following outputs:

```no-highlight
                                     user     system      total        real
Linear Ordered List Search:      0.000000   0.000000   0.000000 (  0.000019)
Binary Ordered List Search:      0.000000   0.000000   0.000000 (  0.000006)

                                     user     system      total        real
Linear Ordered List Search:      0.000000   0.000000   0.000000 (  0.000030)
Binary Ordered List Search:      0.000000   0.000000   0.000000 (  0.000011)

                                     user     system      total        real
Linear Ordered List Search:      0.000000   0.000000   0.000000 (  0.000021)
Binary Ordered List Search:      0.000000   0.000000   0.000000 (  0.000007)
```

In every case, we find that given the same ordered list, the **binary search** is an order of magnitudes **more efficient** than the **linear search**.

### But Wait, There's More

Given the evidence above, you'd be tempted to always default to using a binary search to solve all of your searching problems and that'd be a fair (albeit naive) approach. Are there cases then, where linear search trumps binary search?

Take for example the following list given to both our existing linear and binary search functions:

```ruby
ordered_names = ['Aaron','Adam','Alan','Albert','Alice','Amanda']
name_to_find 'Amanda'
```

The following are outputs from multiple runs of our program:

```no-highlight
                           user     system      total        real
Linear Search:         0.000000   0.000000   0.000000 (  0.000018)
Binary Search:         0.000000   0.000000   0.000000 (  0.002497)


                           user     system      total        real
Linear Search:         0.000000   0.000000   0.000000 (  0.000010)
Binary Search:         0.000000   0.000000   0.000000 (  0.002342)

                           user     system      total        real
Linear Search:         0.000000   0.000000   0.000000 (  0.000010)
Binary Search:         0.000000   0.000000   0.000000 (  0.002087)
```

Bet you didn't see that coming!

Turns out that depending on the amount of data you're working with and how costly your comparisons are inside your loops, linear search can have a leg up. In our case, because the list was so small, it was faster to iterate over the list from start to finish then it was to go through the process of splitting the list, examining which half to work with next and finally running the search.

The best answer is not always the obvious one and sometimes it will take some experimenting with the data, the domain constraints and different algorithms to determine the best approach.
