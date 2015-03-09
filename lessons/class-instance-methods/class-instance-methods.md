With object-oriented programming we can create instances of classes that combine data and the methods that operate on that data into a single unit. Occasionally we need ways to also define methods outside the context of an instance. In this article we compare instance methods to **class methods** which let us define methods that do not depend on any particular instance of a class.

### Learning Goals

* Understand the differences between instance and class methods
* Understand when class methods are useful
* Define a class method using the `def self.method_name` syntax

### Instance Methods

Dealing with dates and times is a requirement for many applications. Let's consider how we can design a Date class to model calendar dates so that it becomes easier to work with them (note that this class already exists in the [Ruby standard library](http://ruby-doc.org/stdlib-2.2.0/libdoc/date/rdoc/Date.html). Here is an example of how we might instantiate a new date object and call some methods on it:

```ruby
date = Date.new(2015, 3, 9)

date.leap_year?
# => false

date.month_name
# => "March"

date.to_s
# => "March 3, 2015"
```

To create the date object we must supply the year, month, and day as integers. Once it is instantiated we can ask if it represents a leap year, what the full name of the month is, or to print out the string representation for display purposes.

This class can be implemented with the following definition:

```ruby
class Date
  MONTH_NAMES = {
    1 => "January", 2 => "February", 3 => "March",
    4 => "April", 5 => "May", 6 => "June",
    7 => "July", 8 => "August", 9 => "September",
    10 => "October", 11 => "November", 12 => "December"
  }

  def initialize(year, month, day)
    @year = year
    @month = month
    @day = day
  end

  def leap_year?
    ((@year % 4 == 0) && (@year % 100 != 0)) || (@year % 400 == 0)
  end

  def month_name
    MONTH_NAMES[@month]
  end

  def to_s
    "#{month_name} #{@day}, #{@year}"
  end
end
```

In addition to our constructor, we define three methods that act on this date object. Each of these methods rely on some data within the object: the `month_name` method relies on the `@month` instance variable, `leap_year` relies on `@year`, and `to_s` relies on all three instance variables. We refer to these methods as **instance methods** since they are specific to a particular instance of the Date class.

### Methods with No Instance

We frequently encode dates as strings so it is easier to store them in files and databases. One popular format used is [ISO 8601](http://en.wikipedia.org/wiki/ISO_8601) which allows us to encode dates as _YYYY-MM-DD_ representing the year, month, and day separated by dashes. Let's write some code to convert these strings to Date objects.

```ruby
# Initially receive a date in string format, possibly from user
# input or from querying a database.
date_string = "2015-03-09"

# Split apart the string to isolate the year, month, and day.
tokens = date_string.split("-")
year = tokens[0].to_i
month = tokens[1].to_i
day = tokens[2].to_i

# Finally create the date object from the individual bits of data
# so that we can utilize the methods we defined earlier.
date = Date.new(year, month, day)

date.to_s
# => "March 3, 2015"
```

This code is specific to our Date class but how can we wrap it in a method if we haven't created a Date object yet?

```ruby
# How can we call parse unless the Date object exists?
date = Date.new(??, ??, ??)
date.parse("2015-03-09")

date.to_s
# => "March 3, 2015"
```

One solution is to pass in some dummy data that we expect to be overwritten:

```ruby
# Initialize with some dummy values.
date = Date.new(nil, nil, nil)
date.parse("2015-03-09")

date.to_s
# => "March 3, 2015"
```

The problem is that our date object is in an invalid state between the `Date.new` and `date.parse` calls. The `Date.new(nil, nil, nil)` doesn't really contain anything useful except for providing an instance to call `parse` on.

What we can do instead is to define a method on the **class itself**:

```ruby
date = Date.parse("2015-03-09")

date.to_s
# => "March 3, 2015"
```

The `parse` method is different in that it does not operate on a particular Date _instance_, but rather the Date class itself. This is known as a **class method** and can be called on the class directly. Let's see what this would look like in our existing implementation:

```ruby
class Date
  MONTH_NAMES = {
    1 => "January", 2 => "February", 3 => "March",
    4 => "April", 5 => "May", 6 => "June",
    7 => "July", 8 => "August", 9 => "September",
    10 => "October", 11 => "November", 12 => "December"
  }

  def initialize(year, month, day)
    @year = year
    @month = month
    @day = day
  end

  def leap_year?
    ((@year % 4 == 0) && (@year % 100 != 0)) || (@year % 400 == 0)
  end

  def month_name
    MONTH_NAMES[@month]
  end

  def to_s
    "#{month_name} #{@day}, #{@year}"
  end

  def self.parse(iso8601_string)
    tokens = iso8601_string.split("-")
    year = tokens[0].to_i
    month = tokens[1].to_i
    day = tokens[2].to_i

    Date.new(year, month, day)
  end
end
```

To define a class method we prefix the name of the method with `self`. In this case we have `def self.parse` which defines the `parse` method on the Date object, enabling us to call `Date.parse` rather than having to call it on an instance of Date. Because a class method is not being called on an instance, it **does not** have access to instance data (i.e. you cannot reference instance variables within the class method).

When should class methods be used? There are two primary use cases where they come in handy:

**Alternate constructors**: In Ruby we can only have a single constructor for a class (i.e. only one implementation of `def initialize`). In some cases it is useful to be able to construct an object multiple ways depending on different types of input. In the example above we needed two ways to construct a date: passing in distinct year, month, and day values or by passing in an ISO 8601 string. The `Date.parse` class method exists as an alternative to `Date.new` and allows us to provide other means for initializing an object (even though `Date.parse` utilizes `Date.new` internally).

**Utility methods**: If a method does not depend on the existence of an instance of that class it may be more useful to include it as a class method. For example, we may have a `Recipe` class that defines a method to convert ounces to grams:

```ruby
Recipe.ounces_to_grams(6)
# => 170.1
```

Because we might want to convert between ounces and grams without creating a recipe object, defining this as a class method makes the functionality useful in more cases. Instance methods can call class methods, but class methods cannot call instance methods.

### In Summary

**Instance methods** are methods that depend on a particular instance of a class. These methods have access to the the internal data of that object via any instance variables that have been defined.

For functionality that does not depend on a particular instance of a class we can utilize **class methods**. Class methods are called on the class itself and are defined by using the `def self.method_name` syntax. Class methods do not have access to instance variables since the method is not being called on any particular instance.

Class methods are used as ways to define alternate constructors for classes as well as a for utility methods that operate independently of any data within an instance.
