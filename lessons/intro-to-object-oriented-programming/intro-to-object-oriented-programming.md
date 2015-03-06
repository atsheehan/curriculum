Object-oriented programming is a popular technique for managing the complexity of software. By associating methods with a specific object, we can combine data with the behavior that operates on it and treat it as a single unit. In this article we'll walk through an example of how we can convert an imperative-style program into an object-oriented one and why it is beneficial.

### Learning Goals

* Learn why it can be useful to combine data and behavior
* Create a custom type by defining a class
* Store data using instance variables

### Report Cards

Consider an application that calculates a student's final grade. Given a student's name and their test scores (which we'll assume are weighted equally), we want to print out their final grade as well as some additional metrics (e.g. max, min, and average score). As a first pass at this program we might compute everything sequentially:

```ruby
first_name = "Bob"
last_name = "Loblaw"
test_scores = [82, 91, 88, 98, 71]

# Iterate through each test score to find the highest one.
max_score = test_scores.first

test_scores.each do |score|
  if score > max_score
    max_score = score
  end
end

# Iterate through each test score to find the lowest one.
min_score = test_scores.first

test_scores.each do |score|
  if score < min_score
    min_score = score
  end
end

# Computer the average score by adding up the values and dividing
# by the count.
total_score = 0.0

test_scores.each do |score|
  total_score += score
end

average_score = total_score / test_scores.length

# Assign a letter grade based on the average score.
if average_score >= 90.0
  letter_grade = "A"
elsif average_score >= 80.0
  letter_grade = "B"
elsif average_score >= 70.0
  letter_grade = "C"
elsif average_score >= 60.0
  letter_grade = "D"
else
  letter_grade = "F"
end

# Output the results to the screen.
puts "Scores for #{first_name} #{last_name}"
puts
puts "Final Grade: #{letter_grade}"
puts "Average Score: #{average_score}"
puts "Max Score: #{max_score}"
puts "Min Score: #{min_score}"
```

If our program did not require any additional features, this solution might be satisfactory. Everything is computed in one pass, top-down, and we print the results at the end.

It is a bit cluttered though and if we didn't have the inline comments it might take a moment to figure out what this code is doing. Let's see if we can refactor it to use methods that will describe each step of the process:

```ruby
first_name = "Bob"
last_name = "Loblaw"
test_scores = [82, 91, 88, 98, 71]

max = max_score(test_scores)
min = min_score(test_scores)
avg = average_score(test_scores)
grade = letter_grade(avg)

puts summary(first_name, last_name, grade, avg, max, min)
```

Here we're focusing on **what** we want to accomplish rather than **how** we can compute it. We start with some initial data and then specify some methods to transform that data into the values that we care about. Notice how we don't really need those comments anymore since the names of the methods explain what is happening. Once we figured out the methods we want to build, we can worry about their implementation:

```ruby
def max_score(scores)
  max = scores.first

  scores.each do |score|
    if score > max
      max = score
    end
  end

  max
end

def min_score(scores)
  min = scores.first

  scores.each do |score|
    if score < min
      min = score
    end
  end

  min
end

def average_score(scores)
  total = 0.0

  scores.each do |score|
    total += score
  end

  total / scores.length
end

def letter_grade(average_score)
  if average_score >= 90.0
    "A"
  elsif average_score >= 80.0
    "B"
  elsif average_score >= 70.0
    "C"
  elsif average_score >= 60.0
    "D"
  else
    "F"
  end
end

def summary(first, last, grade, average, max, min)
  <<SUMMARY
Scores for #{first} #{last}

Final Grade: #{grade}
Average Score: #{average}
Max Score: #{max}
Min Score: #{min}
SUMMARY
end
```

We actually end up with more lines of code using methods in this case, but the benefit is that our original program is now more readable since we can assign names to the methods specifying what they are doing. Also, if we ever need to compute an average score or the letter grade in some other part of the program we can reuse these methods and avoid having to write duplicate code.

### Grouping Data

Notice how we have three pieces of information about a student: their first name, last name, and test scores. These facts are stored in separate variables which we can use throughout the program. But what happens if we want to compute the final grade for more than one student? We could create separate variables for each student, but this isn't really flexible and we'd need to know how many students there are up front. Rather, we could use an array to handle an arbitrary amount of students:

```ruby
first_names = ["Bob", "Barry", "Bilbo"]
last_names = ["Loblaw", "Zuckerkorn", "Baggins"]
test_scores = [[82, 91, 88, 98, 71], [52, 68, 39, 71, 72], [75, 84, 88, 68, 81]]
```

This may work but it becomes tedious to keep these three attributes tied together. Each array only contains a single attribute and we'd have to link multiple arrays together to form a complete student. An alternative approach would be to group the attributes for a single student together in a single data structure:

```ruby
student = { first_name: "Bob", last_name: "Loblaw", test_scores: [82, 91, 88, 98, 71] }
```

Each structure (in this case a hash) contains all of the attributes for a _single_ student. If we wanted to represent multiple students, we can combine these structures into an array:

```ruby
students = [
  { first_name: "Bob", last_name: "Loblaw", test_scores: [82, 91, 88, 98, 71] },
  { first_name: "Barry", last_name: "Zuckerkorn", test_scores: [52, 68, 39, 71, 72] },
  { first_name: "Bilbo", last_name: "Baggins", test_scores: [75, 84, 88, 68, 81] }
]
```

We can modify our original program to run through the list of students and print out their grade summary:

```ruby
students.each do |student|
  max = max_score(student[:test_scores])
  min = min_score(student[:test_scores])
  avg = average_score(student[:test_scores])
  grade = letter_grade(avg)

  puts summary(student[:first_name], student[:last_name], grade, avg, max, min)
end
```

### Combining Data With Behavior

Now we have our student data grouped into a single structure and we also have a set of methods that can act on that data. For most of the methods we end up passing some of our student information as arguments:

```ruby
max_score(student[:test_scores])
min_score(student[:test_scores])
average_score(student[:test_scores])
summary(student[:first_name], student[:last_name], grade, avg, max, min)
```

These methods we defined are specific to students and rely on the this data to function. It doesn't make sense to call `summary` unless we are using it to display the student's report card.

Right now our data is independent from our methods that act on it so we have to pass it in explicitly as an argument. It would be nice if we could somehow _combine our data with the methods that operate on it_ so that they can be treated as a single unit:

```ruby
student.max_score
student.min_score
student.average_score
student.letter_grade
student.summary
```

Rather than having to pass our student into each method explicitly, we can define methods that have _implicit access_ to the data. This is a fundamental principle of **object-oriented programming**: combining information and the behavior that acts on it into a single object. We no longer pass around inert data in our programs but rather custom objects that respond to methods that we define.

Let's see how we might refactor our program to use custom **Student** objects rather than hashes:

```ruby
students = [
  Student.new("Bob", "Loblaw", [82, 91, 88, 98, 71]),
  Student.new("Barry", "Zuckerkorn", [52, 68, 39, 71, 72]),
  Student.new("Bilbo", "Baggins", [75, 84, 88, 68, 81])
]

students.each do |student|
  puts student.summary
end
```

Notice how we stripped out all of the code to compute each metric explicitly. Instead we create a few student objects from their names and grades and then ask for the summary to print out. Because the summary method is now a part of the student object, it has access to the student's name and scores and can compute their final grade internally. All we care about is the end result: printing their summary to the screen.

### Building Custom Objects

So how do we actually define methods on an object? The way we can accomplish this is to create a custom data type by defining a **class**. A class is a template for an object we want to create that allows us to specify what data we want to store and define methods to act on that data. In the previous example we were creating `Student` objects so we'll have to define a `Student` class for that to work:

```ruby
class Student
end
```

We've now defined a custom data type called `Student`, although it doesn't really do much. If we wanted to create an **instance** of this data type we can call the **new** method on the class:

```ruby
some_student = Student.new
```

Again, this object doesn't have any functionality yet because our class is empty, but there is a very important distinction to make here. The **Student** is a class which acts as a template for creating **objects**. The class itself describes what a student is, but an object represents the actual student. We can create these objects by calling the **new** method on a class to generate a new instance of that type.

The example above specifies the first name, last name, and scores when creating a new Student object:

```ruby
bob = Student.new("Bob", "Loblaw", [82, 91, 88, 98, 71])
barry = Student.new("Barry", "Zuckerkorn", [52, 68, 39, 71, 72])
bilbo = Student.new("Bilbo", "Baggins", [75, 84, 88, 68, 81])
```

To pass in this information we need to define a special method in our class called the **constructor**. This constructor allows us to save the information we use to create the object:

```ruby
class Student
  # The constructor is always called `initialize`
  def initialize(first_name, last_name, scores)
    @first_name = first_name
    @last_name = last_name
    @scores = scores
  end
end
```

The `def initialize` line indicates that to create a new student object, we need to supply three arguments: their first name, last name, and scores. This mirrors the `Student.new("Bob", "Loblaw", [82, 91, 88, 98, 71])` call in our example. The `Student.new` and `def initialize` methods are linked: calling `new` on the Student class will trigger the `initialize` method we have defined.

The next step is to store the information for later use in our object. For example, the `summary` method needs the student's name and scores to generate the appropriate report:

```ruby
# We supply our initial data here
bob = Student.new("Bob", "Loblaw", [82, 91, 88, 98, 71])

# But we need to use it down here
bob.summary
```

To ensure that we have access to this data throughout the student object we can utilize **instance variables**. An instance variable has a longer lifetime than ordinary variables in that they exist as long as the object exists and can be accessed anywhere within the object.

To define an instance variable, start the variable name with the `@` symbol. Our constructor before received three pieces of information that it stored in instance variables for later use:

```ruby
def initialize(first_name, last_name, scores)
  @first_name = first_name
  @last_name = last_name
  @scores = scores
end
```

We'll see how we can utilize these variables in subsequent methods for our student. Let's turn our attention to defining new methods for our class. In our example we iterate over each student in the array and print out their summary:

```ruby
students.each do |student|
  puts student.summary
end
```

For `student.summary` to work, we need to define the `summary` method in our student class:

```ruby
class Student
  def initialize(first_name, last_name, scores)
    @first_name = first_name
    @last_name = last_name
    @scores = scores
  end

  def summary
    <<SUMMARY
Scores for #{@first_name} #{@last_name}

Final Grade: ???
Average Score: ???
Max Score: ???
Min Score: ???
SUMMARY
  end
end
```

Notice how we can reference the `@first_name` and `@last_name` within our summary method. Since we set these instance variables when we initially constructed the student, they remain accessible for the lifetime of this object.

But we're no longer passing in any information to the summary method, so how do we print the max, min, average, and letter grade for the student? Because we stored the list of test scores in the `@scores` instance variable, we can compute these other metrics internally and use them within our class. Let's define some additional methods to calculate these values that we can reference from within our summary method:

```ruby
class Student
  def initialize(first_name, last_name, scores)
    @first_name = first_name
    @last_name = last_name
    @scores = scores
  end

  def summary
    <<SUMMARY
Scores for #{@first_name} #{@last_name}

Final Grade: #{letter_grade}
Average Score: #{average_score}
Max Score: #{max_score}
Min Score: #{min_score}
SUMMARY
  end

  def letter_grade
    # ???
  end

  def average_score
    # ???
  end

  def max_score
    # ???
  end

  def min_score
    # ???
  end
end
```

We split the responsibility of calculating each metric into a separate method within our class. Since we have access to the `@scores` instance variable, we can define these methods by modifying our existing implementation:

```ruby
class Student
  def initialize(first_name, last_name, scores)
    @first_name = first_name
    @last_name = last_name
    @scores = scores
  end

  def summary
    <<SUMMARY
Scores for #{@first_name} #{@last_name}

Final Grade: #{letter_grade}
Average Score: #{average_score}
Max Score: #{max_score}
Min Score: #{min_score}
SUMMARY
  end

  def max_score
    max = @scores.first

    @scores.each do |score|
      if score > max
        max = score
      end
    end

    max
  end

  def min_score
    min = @scores.first

    @scores.each do |score|
      if score < min
        min = score
      end
    end

    min
  end

  def average_score
    total = 0.0

    @scores.each do |score|
      total += score
    end

    total / @scores.length
  end

  def letter_grade
    if average_score >= 90.0
      "A"
    elsif average_score >= 80.0
      "B"
    elsif average_score >= 70.0
      "C"
    elsif average_score >= 60.0
      "D"
    else
      "F"
    end
  end
end
```

Notice how the `letter_grade` method utilizes the `average_score` method in its implementation. Methods within a class have access to both the instance variables and other methods, allowing us to re-use existing functionality to build more complex behaviors.

At this point our class is complete and we should be able to use it to print out the student summaries:

```ruby
students = [
  Student.new("Bob", "Loblaw", [82, 91, 88, 98, 71]),
  Student.new("Barry", "Zuckerkorn", [52, 68, 39, 71, 72]),
  Student.new("Bilbo", "Baggins", [75, 84, 88, 68, 81])
]

students.each do |student|
  puts student.summary
end
```

### In Summary

We often run into scenarios where we have methods that operate on a specific type of data. **Object-oriented programming** is a paradigm that lets us combine this data and any associated methods into a single object.

To add methods to an object we need to create a custom data type by defining a **class**. A class is a template for creating objects with specific data and methods that act on that data.

To create an object using a class we rely on the **new** method. This method is known as the **constructor** and will define a new object of the given type.

To store data within an object we rely on **instance variables**. An instance variable starst with the `@` symbol and is available throughout the lifetime of an object.
