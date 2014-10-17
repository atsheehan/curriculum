Expressions are an essential part of programming and are how we instruct Ruby to transform data from one value to another. In this article we discuss what it means to evaluate an expression and demonstrate how variables can be used to make our programs more flexible.

### Learning Goals

* Evaluate an expression in Ruby using `irb`.
* Understand how variables are evaluated in expressions.
* Use variables to improve readability.

### Mathematical Expressions

Before we look at any Ruby code, let's consider some expressions you may have seen before. What is the value of the following:

```no-highlight
2 + 2
```

If you've answered **4**, congratulations! With any kind of basic training in arithmetic we know that the *+* operator indicates that the numbers on the left and the right of the *+* should be added together. After that operation we're left with just a single number:

```no-highlight
2 + 2
4
```

How about the following expression:

```no-highlight
7 * (5 + 1)
```

This evaluates to **42**, but how do we arrive at that number? There are two operations to perform: an addition and a multiplication. Which one do we perform first? In Mathematics we have an [order of operations][order-of-operations] which specifies how we can reduce complex expressions to simplified values. The parentheses around the addition expression indicate that we should perform the addition first and then multiply that result by *7*:

```no-highlight
7 * (5 + 1)
7 * 6
42
```

Let's see one more example:

```no-highlight
5 + ((5 + 2) * (10 - 1)) / 3
```

This is a bit daunting but we can use the same order of operations to evaluate this expression one operation at a time:

```no-highlight
5 + ((5 + 2) * (10 - 1)) / 3
5 + (7 * (10 - 1)) / 3
5 + (7 * 9) / 3
5 + 63 / 3
5 + 21
26
```

Even as our expressions get more and more elaborate, we can use the same procedure and order of operations to reduce them to a single value. This process of evaluating expressions is similar to how programming languages interpret the code we write. We can perform the same calculations in Ruby and we'll see the same results:

```no-highlight
$ irb

> 1 + 1
=> 2

> 7 * (5 + 1)
=> 42

> 5 + ((5 + 2) * (10 - 1) / 3)
=> 26
```

These form **expressions** in Ruby. An expression is some combination of values and operations that ultimately evaluate to some other value. *1 + 1* evaluates to *2*, *7 * (5 + 1)* evaluates to *42*, and *5 + ((5 + 2) * (10 - 1)) / 3* evaluates to *26*. Ruby is simplifying these expressions until we end up with a single value.

### Variables

We don't have to always know the values being used in our expressions. In many applications, we can use **variables** as placeholders which make our programs more generic and flexible.

What would the following expression evaluate to:

```no-highlight
x + 1
```

Unless we know what *x* is, we can't evaluate this expression. If we asked Ruby to help us out we'll get an error:

```no-highlight
$ irb

> x + 1
NameError: undefined local variable or method "x"
```

If we defined *x* to have a value of *5* then we could revisit our expression:

```no-highlight
x + 1
5 + 1
6
```

In this case *x* is a **variable**, a placeholder for some value. If we haven't defined what that value is, we can't evaluate the expression that uses it. In Ruby, we can define a variable by assigning some value to it using the `=` operator:

```no-highlight
$ irb

> x = 5
=> 5

> x + 1
=> 6
```

The `=` symbol in Ruby is the **assignment operator**. It takes the value on the right of the equals sign and *assigns* it to the variable on the left. By doing so, we can now use this variable to access the value that was assigned to it.

So what's the benefit of using variables instead of their values directly? Variables allow us to assign meaningful names to our values so that our programs are easier to understand. What does the following expression do?

```ruby
18.0 * 40.0 * 52
```

Well, we can figure out that it evaluates to *37440.0*, but what is the significance of that value? What if we replaced these numbers with appropriately named variables instead:

```ruby
hourly_wage = 18.0
hours_per_week = 40.0
weeks_per_year = 52

hourly_wage * hours_per_week * weeks_per_year
```

Now it's a bit clearer what we're doing. The last expression is calculating the annual salary for an hourly employee. The end result is the same as the previous snippet of code but it's a lot easier to understand what each value represents when they are stored in variables with meaningful names.

Variables also allow our programs to be more generic. We know the formula for calculating an annual salary but maybe we don't know the hourly wage yet, or we want this program to be used by many different employees whose hourly rate might vary. Let's write a program that prompts the user to enter their rate and hours worked and we'll output their annual salary:

```ruby
weeks_per_year = 52

print "Hourly wage: "
hourly_wage = gets.chomp.to_f

print "Hours worked per week: "
hours_per_week = gets.chomp.to_f

annual_salary = hourly_wage * hours_per_week * weeks_per_year
puts "Your annual salary is #{annual_salary}"
```

Here we've replaced our `hourly_wage` and `hours_per_week` values with `gets.chomp.to_f`. What this will do is wait for the user to type in a value (`gets.chomp`) and then convert it to a number (`to_f`). When we run the program it might look like:

```no-highlight
$ ruby salary.rb
Hourly wage: 18.0
Hours worked per week: 40.0
Your annual salary is 37440.0

$ ruby salary.rb
Hourly wage: 12.0
Hours worked per week: 25.0
Your annual salary is 15600.0
```

Our program is a lot more useful since it can be re-used with different inputs to generate the annual salary. The value of our program comes from the expression that evaluates the annual salary from the employee inputs and saves it to a new variable:

```ruby
annual_salary = hourly_wage * hours_per_week * weeks_per_year
```

This expression stays the same but the variables can contain different values each time the program is run, making this program much more flexible.

### Constants

One thing to notice is that we only prompt for two of the three inputs into the expression: `hourly_wage` and `hours_per_week` are specific to each employee but `weeks_per_year` is fixed to *52* for everyone. Why don't we just hard-code *52* in the expression:

```ruby
annual_salary = hourly_wage * hours_per_week * 52
```

Well, this comes back to using variables for readability. We don't need a variable to represent *weeks_per_year* since it will always be *52* (or, we'll always approximate it to be *52*), but it makes the program easier to understand when we can give it a name.

We often call these variables *constants* in that their value is fixed but we want to name them so they can be referenced in other places. The convention in most programming languages (including Ruby) is to specify the name in all caps to signify that the value of this variable should not change:

```ruby
WEEKS_PER_YEAR = 52

print "Hourly wage: "
hourly_wage = gets.chomp.to_f

print "Hours worked per week: "
hours_per_week = gets.chomp.to_f

annual_salary = hourly_wage * hours_per_week * WEEKS_PER_YEAR
puts "Your annual salary is #{annual_salary}"
```

Constants greatly improve readability and if we ever need to change the value of a constant, we can do so in one place:

```ruby
WEEKS_PER_YEAR = 52.1775
```

### In Summary

Why do we care about expressions? Most programs we write are responsible for transforming data from one value to another and expressions are a primary mechanism for doing so. Expressions are not just limited to mathematical computations as we've seen here. Expressions can contain many types of operations on different types of data, but we still follow a similar order of operations to reduce these expressions to a single value.

Variables allow us to give meaningful names to certain values and let us use placeholders within our expressions. These placeholders make our programs more abstract and flexible so that they can be used for a wide variety of inputs. We can also use constants as ways to assign names to fixed values so that they are easier to read in our program and let us change these values in a single place.

[order-of-operations]: http://en.wikipedia.org/wiki/Order_of_operations
