Our computers spend a great deal of time sorting data that make it easier for us to consume in human-readable formats. As web developers, our tools can often make it easy to overlook the value of grasping concepts like sorting and the the algorithms behind their implementations.

When we think of sorting, we imagine that given a list of elements that have some ordinal aspect to them, we ought to be able to quickly sort that list in some ascending or descending order. It turns out that the algorithm used to perform the sort has a tremendous impact of the overall efficiency (in time and resources) of the operation. Algorithm efficiency is a broad topic in Computer Science and one we won't dive into deeply here but we will present a few examples written in Ruby and point you to some external reference material for further exploration.

### Learning Goals

* Implement a Selection Sort
* Implement an Insertion Sort
* Implement a Bubble Sort

### Selection Sort

Of the sorting algorithms, **selection sort** is one of the simpler ones to explain and follow. Given a deck of numbered flash cards, if you were asked to sort them in ascending order, you might find the smallest card in the deck and bring it to the top. You would then repeat the process for the remainder of the deck until all the cards have been sorted. The selection sort has complexity O(n<sup>2</sup>).

![Selection Sort (Source: Wikipedia)](https://s3.amazonaws.com/hal-assets.launchacademy.com/sorts/selection-sort-wikipedia.gif)

Implemented in Ruby, the algorithm might look like so:

```ruby
# Source: "Sorting Algorithms Part 1"

def selection_sort(to_sort)
  for index in 0..(to_sort.length - 2)
    # select the first element as the temporary minimum
    index_of_minimum = index

    # iterate over all other elements to find the minimum
    for inner_index in index..(to_sort.length - 1)
      if to_sort[inner_index] < to_sort[index_of_minimum]
        index_of_minimum = inner_index
      end
    end

    if index_of_minimum != index
      to_sort[index], to_sort[index_of_minimum] = to_sort[index_of_minimum], to_sort[index]
    end
  end

  return to_sort
end
```

### Insertion Sort

The **insertion sort** works by building a list of sorted items one at a time. We start with the first element of the list, declaring it sorted. We subsequently loop through each remaining element and inserting it in the correct position in our sorted list. This method can be slower than other algorithms for large lists but it is simple to implement and adequate for small lists. The insertion sort also has complexity O(n<sup>2</sup>).

![Insertion Sort (Source: Wikipedia)](https://s3.amazonaws.com/hal-assets.launchacademy.com/sorts/insertion-sort-wikipedia.gif)

Sample Ruby implementation:

```ruby
# Source: "Sorting Algorithms Part 1"

def insertion_sort(to_sort)
  # index starts at one, we can skip the first element, since we would
  # otherwise take it and place it in the first position, which it already is
  for index in 1..(to_sort.length - 1)
    for inner_index in 0..(index - 1)
      if to_sort[inner_index] >= to_sort[index]
          to_sort.insert(inner_index, to_sort[index])
          to_sort.delete_at(index + 1)
      end
    end
  end

  return to_sort
end
```


### Bubble Sort

The **Bubble Sort** algorithm operates on the premise that repeatedly placing neighboring elements in order will eventually yield an ordered list. To that end, it iterates over the array, comparing two elements at a time and pushing the highest value towards the end of the array. This is done until no additional swaps can be performed. The bubble sort also has complexity of O(n<sup>2</sup>) but can sometimes outperform the likes of the insertion and selection sorts on smaller lists.

![Bubble Sort (Source: Wikipedia)](https://s3.amazonaws.com/hal-assets.launchacademy.com/sorts/bubble-sort-example-from-wikipedia.gif)

Sample Ruby implementation:

```ruby
# Source: "Sorting Algorithms Part 1"

def bubble_sort(to_sort)
  sorted = false

  until sorted
      sorted = true

      for index in 0..(to_sort.length - 2)
        if to_sort[index] > to_sort[index + 1]
          sorted = false
          to_sort[index], to_sort[index + 1] = to_sort[index + 1], to_sort[index]
        end
      end
  end

  return to_sort
end
```

### Comparing Sorting Algorithms

It is not uncommon to compare algorithms in order to determine which is more efficient for the task at hand. In this section, we will use the three algorithm implementations above on two sets of numbers to determine the fastest at sorting each set. We'll use the built-in Ruby `Benchmark` module to time each sort.

We will use two sample sets in our demonstrations, a small 1,000 element list and a larger 5,000 element list:

* Small set: [Downloadable CSV](https://s3.amazonaws.com/hal-assets.launchacademy.com/sorts/number_list_small.csv)
* Large set: [Downloadable CSV](https://s3.amazonaws.com/hal-assets.launchacademy.com/sorts/number_list_large.csv)

#### Comparison Source

```ruby

# comparision.rb (includes sorting methods above)

puts "Small Set"
numbers = IO.read('small_number_list.csv').split(',').map(&:to_i)
Benchmark.bm(15) do |r|
  r.report("Selection Sort") { selection_sort(numbers) }
  r.report("Insertion Sort") { insertion_sort(numbers) }
  r.report("Bubble Sort") { bubble_sort(numbers) }
end

puts; puts "---------"; puts

puts "Large Set"
numbers = IO.read('large_number_list.csv').split(',').map(&:to_i)
Benchmark.bm(15) do |r|
  r.report("Selection Sort") { selection_sort(numbers) }
  r.report("Insertion Sort") { insertion_sort(numbers) }
  r.report("Bubble Sort") { bubble_sort(numbers) }
end
```

#### Comparison Results

```no-highlight
Small Set
                      user     system      total        real
Selection Sort    0.050000   0.000000   0.050000 (  0.054089)
Insertion Sort    0.050000   0.000000   0.050000 (  0.052788)
Bubble Sort       0.000000   0.000000   0.000000 (  0.000121)

---------

Large Set
                      user     system      total        real
Selection Sort    1.350000   0.000000   1.350000 (  1.350633)
Insertion Sort    1.340000   0.000000   1.340000 (  1.344096)
Bubble Sort       0.000000   0.000000   0.000000 (  0.000572)
```

Our results surprisingly showed us that with both small and larger (by comparison) data sets, the bubble sort outperformed the selection and insertion sort algorithms.

### Why this matters

You may find that your day-to-day does not call on the analysis and comparison of algorithms however, as a software developer, the efficiency of your code and the overall performance of your software as a result of that efficiency (or lack thereof) has a very real impact on the quality of your application.

Learning how to express algorithm complexity and taking the time to implement them in Ruby will yield benefits that may not be immediately apparent.

### Resources

* [Sorting Algorighms in Ruby](http://jlarusso.github.io/blog/2013/04/30/sorting-algorithms-in-ruby/)
* [Sorting Algorithms Part 1](http://gillesleblanc.wordpress.com/2012/04/10/sorting-algorithms-in-ruby/)
* [Sorting Algorithms Part 2](http://gillesleblanc.wordpress.com/2012/04/21/sorting-algorithms-in-ruby-part-2/)
* [Sorting Algorithms Part 3](http://gillesleblanc.wordpress.com/2012/05/01/sorting-algorithms-in-ruby-part-3/)
