In this article we'll discuss **Big-O Notation**, a language for describing how certain algorithms change as they deal with larger amounts of data.

### Learning Goals

* Use Big O notation to describe the growth rate of a function
* Understand the common complexity types and their characteristics

### Performance

Although it would be nice to have all of our applications run as efficiently and smoothly as possible, for a large number of software projects performance isn't a major concern. Computers today have enough processing power and memory to run a staggering amount of computations in fractions of a second. It's usually not worth spending the time to optimize an application unless we notice that it is running particularly slow.

Things change when we start to consider how our application behaves when dealing with larger amounts of data. Consider searching a database table containing 100 rows. We could probably get away with scanning all 100 rows each time we search for a record, but what happens when the table grows to contain 10 million rows? Repeatedly scanning 10,000,000 records would be impractical. We would probably switch from a sequential search to the much faster binary search by adding an index which requires checking less than 30 rows for each query compared to the 10 million rows before. At this scale, how we perform operations programmatically matters.

Whether we use sequential search or binary search, we're solving the same problem: finding a record in a table. It's important to recognize that there are multiple ways to solve the same problem, each with their own performance trade-offs. We need some way to compare the different approaches to determine which one is more suitable for the application.

#### Analyzing an Algorithm

An **algorithm** is simply a step-by-step procedure to solve a problem. In Ruby, we'd typically implement an algorithm by writing a method that runs through the given procedure. Consider the following code to check whether a specific element exists within an array:

```ruby
def exists?(array, target)
  array.each do |element|
    if element == target
      return true
    end
  end

  false
end
```

Given an array and a target to find, this method will loop over each element and check to see if it equals the target value. We can try it out using an array of random numbers:

```ruby
numbers = [47, 27, 12, 13, 61, 19, 66, 7, 34, 67]

exists?(numbers, 61) # => true
exists?(numbers, 0)  # => false
```

When `exists?` is called, it has to iterate over the `numbers` array to check each element. Sometimes the method can exit early if it finds the target but when the target doesn't exist it has to continue through to the end of the array.

To get a rough sense of how long this method will take we might start by counting how often it has to perform some operation. Given an array with 10 elements, we'll have to run through the `each` block 10 times (or less if the target is found). If we had an array of 100 elements, we'd have to run through the loop 100 times. For a thousand elements, we'd loop one thousand times, and so on.

For this method, we have a linear relationship between the size of the input (i.e. the length of the array), and the number of operations that occur. As the array size increases, the time it takes for the method to finish also increases by a constant amount.

We can describe this relationship more formally using **Big O notation**, which categorizes methods by their rate of growth. If we call the size of the input _n_, we can classify this linear relationship with the _O(n)_ notation. _O(n)_ states that the number of operations used in a method is roughly proportional to the size of the input _n_.

Let's examine another method with a different growth rate. Consider the following code which removes duplicates from an array:

```ruby
def unique(array)
  unique_array = []

  array.each do |original_element|
    found = false

    unique_array.each do |unique_element|
      if original_element == unique_element
        found = true
        break
      end
    end

    if !found
      unique_array << original_element
    end
  end

  unique_array
end
```

This method will return a new array containing all unique values. To do so, it checks each element in the original array against all of the values in the new, unique-only array to see if it already has been added. Notice that we now have two loops, one nested within another:

```ruby
array.each do |original_element|
  # ...
  unique_array.each do |unique_element|
    # ...
```

Although the arrays are not the same size, the unique array will grow to be roughly proportional to the original array. If we were to think about how many times the inner loop runs it would be at least _n_ times for the outer loop plus however many elements are within the inner `unique_array`. Whenever we have two nested loops that are iterating over arrays of roughly the same size we can approximate this method as taking _O(n<sup>2</sup>)_ or _quadratic_ time.

This doesn't mean that if we input an array with 100 elements that it will take 100<sup>2</sup> or 10,000 operations. What _O(n<sup>2</sup>)_ means is that as we increase the size of the input, the number of operations performed will grow quadratically rather than linearly.

### Benchmarking

Let's try measuring the above two code samples to see how they perform with different array sizes. Rather than measuring how long they take in real time (which we could do using the built-in [`Benchmark` module](http://www.ruby-doc.org/stdlib-1.9.3/libdoc/benchmark/rdoc/Benchmark.html)), we'll measure how many times the inner loop runs given inputs of varying sizes. To do this, we can modify both of the methods above to include a `counter` variable that is incremented within the loop:

```ruby
def exists?(array, target)
  found = false
  counter = 0

  array.each do |element|
    counter += 1
    if element == target
      found = true
      break
    end
  end

  printf "exists: input_size: %6d, inner_loops: %d\n", array.length, counter
  found
end
```

```ruby
def unique(array)
  counter = 0

  unique_array = []

  array.each do |original_element|
    found = false

    unique_array.each do |unique_element|
      counter += 1

      if original_element == unique_element
        found = true
        break
      end
    end

    if !found
      unique_array << original_element
    end
  end

  printf "unique: input_size: %6d, inner_loops: %d\n", array.length, counter
  unique_array
end
```

Now we just need to call each method with various inputs:

```ruby
input_sizes = [10, 20, 50, 100, 200, 500, 1000, 2000, 5000]

input_sizes.each do |size|
  # Generate an array containing _size_ random numbers. The numbers are chosen
  # from 0 to _size_ / 2 so that there will be some duplicates.
  input_array = size.times.map { rand(size / 2) }
  unique(input_array)
end

puts

input_sizes.each do |size|
  # Generate an array containing _size_ random numbers and then generate another
  # number to search for within the array.
  input_array = size.times.map { rand(size) }
  target = rand(size)
  exists?(input_array, target)
end
```

Running this code yields the following results on my computer:

```no-highlight
exists: input_size:     10, inner_loops: 10
exists: input_size:     20, inner_loops: 20
exists: input_size:     50, inner_loops: 29
exists: input_size:    100, inner_loops: 27
exists: input_size:    200, inner_loops: 99
exists: input_size:    500, inner_loops: 500
exists: input_size:   1000, inner_loops: 191
exists: input_size:   2000, inner_loops: 1117
exists: input_size:   5000, inner_loops: 4773

unique: input_size:     10, inner_loops: 21
unique: input_size:     20, inner_loops: 79
unique: input_size:     50, inner_loops: 530
unique: input_size:    100, inner_loops: 2012
unique: input_size:    200, inner_loops: 8007
unique: input_size:    500, inner_loops: 46217
unique: input_size:   1000, inner_loops: 187979
unique: input_size:   2000, inner_loops: 743935
unique: input_size:   5000, inner_loops: 4654127
```

For the `exists?` method we can see that the number of times the inner loop is called roughly follows the size of the input (in some cases it will exit early if the target is found). We would say that the method grows _linearly_ with the input size, or that it has _O(n)_ complexity.

For the `unique` method things are a bit different. Every time we increase the input, the number of operations increases by a much larger amount. If we were to plot these values on a graph we could see that the number of inner loops forms a parabola with respect to the size of the input. We would say that the method grows _quadratically_ with the input size, or that it has _O(n<sup>2</sup>)_ complexity.

### Common Classifications

So far we've seen examples of _O(n)_ and _O(n<sup>2</sup>)_ methods, otherwise known as methods with _linear_ and _quadratic_ complexity. There are a handful of other classifications that we'll often run into to describe other methods or algorithms:

#### _O(1)_, or constant time

If a method can run in a constant amount of time regardless of the input size we can classify it as _O(1)_ or as _constant time_. It doesn't necessarily have to take a single operation but the number of operations should not change as the input size changes.

An example of an _O(1)_ operation is accessing an element directly in an array: `array[i]` will take the same amount of time for an array with 10 elements as it will for an array with 10,000 elements. As the array grows, the time it takes to access individual elements does not change.

#### _O(log n)_

Algorithms or methods with _O(log n)_ or _logarithmic_ complexity grow very slowly as the input increases. These algorithms are able to run efficiently on very large input sizes.

One characteristic of these algorithms is that they do not need to inspect every element of the input. Consider the problem of finding a name in a phone book. A phone book might contain many tens of thousands of names yet we're still able to find a person after checking only a handful of pages.

If we were to describe this process, we'd start in the middle of the book and check to see if the person we're looking for comes before or after this page. In either case we know that one-half of the phone book does not contain the person we're looking for and we can eliminate it from our search space. We then repeat this process until we hone in on the specific page and entry that we're searching for.

This process is known as **binary search** and runs in _O(log n)_ time. It can be used to search through huge datasets very quickly as long as they are sorted (if the phone book wasn't sorted, it would take a _lot_ longer to find someone's name). Each step of the process effectively eliminates half of our input without the need to inspect each element.

#### _O(n log n)_

Some algorithms are classified as _O(n log n)_ or _linearithmic_ complexity. These algorithms fall between linear (_O(n)_) and quadratic (_O(n<sup>2</sup>)_). A characteristic of these algorithms is that they inspect all elements at least once (in _O(n)_ time) and perform some _O(log n)_ operation for each of the elements. Many sorting algorithms (such as [Quicksort](http://en.wikipedia.org/wiki/Quicksort) and [Mergesort](http://en.wikipedia.org/wiki/Merge_sort)) run in _linearithmic_ time.

#### _O(2<sup>n</sup>)_ and _O(n!)_

Algorithms with _exponential_ (_O(2<sup>n</sup>)_) or _factorial_ (_O(n!)_) complexity grow very quickly as the size of the input increases. Except for very small input sizes, these problems are essentially unsolvable. For example, an input size of 10 yields something around _2<sup>10</sup> = 1024_ operations. If we increase the input size to 100, we'd be dealing with something in the magnitude of _2<sup>100</sup> = 1267650600228229401496703205376_ operations. If every computer ever made spent every available cycle working on this problem we might expect to receive an answer sometime near the eventual [heat death of the universe](http://en.wikipedia.org/wiki/Heat_death_of_the_universe#Time_frame_for_heat_death).

These types of algorithms usually include brute-force search of all possible combinations of the input. A popular example is the [traveling salesman problem](http://en.wikipedia.org/wiki/Travelling_salesman_problem): given a list of cities and the distances between them, find the shortest possible route to visit all of the cities exactly once and then return to the original city. A brute-force solution would be to list every possible combination of the given cities and find which one has the shortest route. This would result in _n!_ combinations, which for 20 cities would be 2432902008176640000 routes to check.

When confronted with an algorithm that has exponential or factorial complexity it's usually best to look for heuristics that might not yield the _optimal_ solution but one that is "good enough". The traveling salesman is an example of a problem that has lots of approximate solutions that are very close to optimal. It might also be possible to add some constraints to the original problem which allow alternative algorithms to be used which can run in a shorter timeframe (e.g. restricting travel routes between certain cities).

### Premature Optimization

Although performance is important, it's usually preferable to focus on creating applications with clear and maintainable code rather than fast code. The difference between an _O(n)_ and _O(n<sup>2</sup>)_ algorithm is usually not noticeable except for very large inputs. Wait until there is a noticeable slowdown in an application before looking at ways to improve performance.

If there is a need to optimize, it's not always the case that an _O(n)_ will run faster than an _O(n<sup>2</sup>)_ algorithm, especially for small inputs. An _O(n)_ algorithm might spend longer on each element than an _O(n<sup>2</sup>)_ algorithm would. In this case it's important to test and benchmark the performance of both algorithms to choose which one is preferable for the input size being used.

### Resources

* [Wikipedia: Table of common time complexities](http://en.wikipedia.org/wiki/Time_complexity#Table_of_common_time_complexities)
* [StackOverflow: Plain English Explanation of Big O Notation](http://stackoverflow.com/a/487278/181403)
