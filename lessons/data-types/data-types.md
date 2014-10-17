Data types determine how Ruby understands and operates on the information in our programs. In this article we look at a few of the basic data types in Ruby and explore some of the ways they behave.

### Learning Goals

* Understand the difference between the *value* and the *type* of information.
* Know how to use strings, integers, and floats to represent different types of information.
* Call methods on data to modify it in some way.
* Pass additional data into methods as *arguments*.
* Chain multiple method calls together.
* Use `.class` and `.methods` to learn more about some data.
* Convert between strings and numbers using `.to_i` and `.to_f`.

### More Than One Way to Add

What is the result of the following expression:

```ruby
5 + 6
```

We know that the `+` operator adds two numbers together resulting in a value of *11*. But what about this expression:

```ruby
"Bob" + "Loblaw"
```

Well, we're still using the `+` operator but how do we add two words together? In this case we can join them to form one longer word:

```ruby
"Bob" + "Loblaw" # => "BobLoblaw"
```

In both cases we used the `+` operator but the behavior was different depending on the type of data that we were using. In fact, the type of our data is what dictates how we can use it and what operations we may perform on it.

### Data Types

Consider the following questions:

* What is your name?
* How old are you?
* Do you like pizza?

The answer to these questions will vary from person to person, but the **type** of answer should be roughly the same.

When asked what your name is, you might respond with one or more words:

```ruby
name = "Barry Zuckerkorn"
```

We represent words and sentences in Ruby as [**strings**][string]. A string is surrounded by quotes (single or double) and can contain any arbitrary sequence of characters.

If asked how old are you, you might respond with a whole number:

```ruby
age = 9
```

Or maybe you're counting down to the big day and you want to be a bit more precise:

```ruby
age = 9.75
```

Although both answers are numbers, Ruby considers these two different data types. Whole numbers (positive or negative) that don't have a fractional component are represented as **integers** whereas numbers with a decimal place are **floats**.

If you were asked if you liked pizza, you might respond with a *yes* or (less likely) *no*:

```ruby
likes_pizza = "yes"  # who doesn't?
```

We can use a string to represent this answer, but we actually run into these yes-no questions quite often and have a specialized data type called a **boolean** to represent *true* or *false*:

```ruby
likes_pizza = true
```

Booleans are often used to make decisions via *conditional expressions* which we'll discuss in another lesson.

These are just a handful of the primitive data types that you'll often use in Ruby (and other programming languages). Now that we've seen a few different types, let's see what we can do with them.

### Methods

Why do we care about the types of our data? Internally our machines represent all of this data as ones and zeros but assigning types to our data makes it easier for us to understand and manipulate it. Not only does the type reflect what kind of data we're working with, it also defines what operations we may perform on it.

Consider the following expression:

```ruby
"banana".capitalize
```

Without knowing much Ruby, we might guess that this would evaluate to `"Banana"` (and we'd be correct). What about the following?

```ruby
42.capitalize
```

Well, this is a bit strange. We could figure out how the previous expression works because we probably have had to capitalize a word in the past, but how do we capitalize a number? In this case it doesn't make sense and Ruby agrees:

```ruby
> 42.capitalize
NoMethodError: undefined method "capitalize" for 42:Fixnum
```

When we're performing some operation in Ruby, we need to verify whatever we're performing the operation on **supports** that operation. We call these operations **methods** and each data type has a list of methods that it will respond to. Strings support the `capitalize` method but integers do not, whereas an integer supports the `even?` method whereas strings do not.

### Evaluating Methods

The format of a method call is:

```no-highlight
data.method
```

The method is acting on the data to perform some operation. A method is a type of expression in Ruby and when it is evaluated there is some resulting value known as the **return value** of a method.

Let's look at some examples of methods and the values they return:

```ruby
"banana".capitalize #=> returns "Banana"
"foobar".reverse    #=> returns "raboof"
42.even?            #=> returns true
(3.14159).round     #=> returns 3
```

One thing to keep in mind is that most methods return **new** values. For the `reverse` method the string that is being returned is a new copy of the original with the values reversed. This means that the original string `"foobar"` is left unchanged:

```ruby
some_string = "foobar"
reversed_string = some_string.reverse

# some_string and reversed_string are two different values
puts some_string #=> "foobar"
puts reversed_string #=> "raboof"
```

### Arguments

Sometimes methods need additional information. If I want to find a particular word within a larger sentence we can use the `include?` method on a string:

```ruby
sentence = "The quick brown fox jumps over the lazy dog"
sentence.include?("fox")   #=> true
```

We're asking the original sentence if it includes some word by passing in an **argument** to the `include?` method. In this case we're searching for the word *fox* so we have to pass that in as an argument.

Different methods require different amounts and types of arguments. If we want to insert one string into another we can use the `insert` method:

```ruby
"Have a nice day!".insert(7, "very ")
#=> "Have a very nice day!"
```

The `insert` method expects two arguments: the position and the new string we want to insert. This method returns another string with the new word inserted. In general, the format of a method call with arguments is:

```no-highlight
data.method(argument1, argument2, ...)
```

The parentheses are optional for method calls and for methods with no arguments they are often omitted (e.g. `"banana".capitalize` rather than `"banana".capitalize()`).

### Chaining Methods

Methods are often thought of as black boxes: we feed them input (data and arguments) and they produce some output (the return value). If we call the following method:

```ruby
"banana".reverse #=> "ananab"
```

Then `"banana"` is our input and `"ananab"` the output. But our output is just another string which we know we can call methods on:

```ruby
"banana".reverse.upcase
# "ananab".upcase       first reverse the original string
# "ANANAB"              and then upcase the reversed string
```

When we chain multiple methods together Ruby still has to evaluate them one at a time and the return value from one method becomes the input to the next. We can also utilize methods with arguments when chaining them together:

```ruby
word = "foo"

word.gsub("o", "al").insert(3, "af")
# "foo".gsub("o", "al").insert(3, "af")    substitute the variable first
# "falal".insert(3, "af")                  replace all occurrences of "o" with "al"
# "falafal"                                insert a few characters in the middle
```

By chaining methods together we can combine simple methods together to transform our data in much more complex ways.

### Discovering Types and Methods

We've seen a handful of methods for strings and numbers, but how can we find out what other methods there are?

The methods available depends on the *type* of data we're working with. In Ruby all of the data types are defined via **classes** which we'll discuss in another lesson, but there is a `class` method that we can use to print out the type for a value:

```ruby
name = "Gizmo"
name.class #=> String

age = 30
age.class #=> Fixnum

height_in_inches = 70.3
height_in_inches.class #=> Float
```

*Note: The `Fixnum` class is really a specific version of the `Integer` class.*

Once we know the appropriate data type we can then look up available methods in the Ruby documentation for the [String][ruby-string], [Integer][ruby-integer], or [Float][ruby-float] classes, among others.

Another approach is to ask Ruby directly which methods are available on a particular value using the `methods` method:

```ruby
"banana".methods
#=>  [:<=>, :==, :===, :eql?, :hash, :casecmp, :+, :*, :%, :[], :[]=, :insert, :length, :size, :bytesize, :empty?, :=~, :match, :succ, :succ!, :next, :next!, :upto, :index, :rindex, :replace, :clear, :chr, :getbyte, :setbyte, :byteslice, :to_i, :to_f, :to_s, :to_str, :inspect, :dump, :upcase, :downcase, :capitalize, :swapcase, :upcase!, :downcase!, :capitalize!, :swapcase!, :hex, :oct, :split, :lines, ...and so on]
```

Here we can get a list of method names that the *string* type supports. Methods can take on a few different forms, including operations like `+` that we saw earlier:

```ruby
# These two lines are equivalent
"foo" + "bar"  #=> "foobar"
"foo".+("bar") #=> "foobar"
```

The `methods` call is useful when we're dealing with new data types and want to see what's available, but it can be confusing to sift through the large number of entries without any additional documentation. Browsing both the methods list and the Ruby documentation is a great way to get familiar with what methods are available for some of the more common data types.

### Converting Between Types

Consider the following expression:

```ruby
23 > 4 #=> true
```

The fact that this returns true shouldn't come as a surprise to most people. But what if we weren't dealing with integers but strings instead:

```ruby
"23" > "4" #=> false
```

Hmmm. Well, Ruby knows that 23 is larger than 4 when we treat them as numbers, but with strings it's behaving a bit differently. The reason is that strings can contain arbitrary characters so Ruby can't assume they will all be numbers. Instead, it compares character by character and since `"2"` is less than `"4"` the expression evaluates to false.

This makes sense if we were sorting strings and needed to check whether one string is less than or greater than another. For example, we could use this comparison to sort a list of websites:

```no-highlight
23andme.com
4chan.org
99designs.com
altavista.com
# ... more websites sorted alphabetically
```

But what if we really wanted to treat these strings as numbers? We can convert between strings and numbers using `to_f` (for numbers with fractional components) or `to_i` (for whole numbers):

```ruby
pi = "3.14159" #=> Pi is initially a string

pi.to_f #=> 3.14159
pi.to_i #=> 3
```

It's important to realize that converting to an integer will truncate any fractional component. Also, if we try calling `to_i` or `to_f` on a string that does not contain a number we end up with `0` instead.

### In Summary

We represent information in our programs by specifying the value as well as the **type** of data. Ruby has built-in data types for representing words and sentences (strings), numbers (integers and floats), true/false values (boolean), and several other common types.

The type specifies which operations we can perform on the data and these operations are known as **methods**. All methods have input and output. Our input consists of the data we're operating on as well as any additional **arguments**. The output of a method call is the **return value** that is generated when Ruby evaluates the expression.

[string]: http://en.wikipedia.org/wiki/String_(computer_science)
[float]: http://en.wikipedia.org/wiki/Floating_point
[ruby-float]: http://www.ruby-doc.org/core-2.1.3/Float.html
[ruby-integer]: http://www.ruby-doc.org/core-2.1.3/Integer.html
[ruby-string]: http://www.ruby-doc.org/core-2.1.3/String.html
