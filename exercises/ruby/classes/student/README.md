# Student Grades

The `Student` class has been created to represent an individual student enrolled in a course. Each student has a name and a list of assignment grades. To make this class more useful we can add additional methods to calculate their average score and letter grade.

## Instructions

Add the following methods to the `Student` class found in `lib/student.rb`:

* `first_name`: returns the student's first name.
* `last_name`: returns the student's last name.
* `full_name`: returns the student's first and last name.
* `grade_average`: returns the grade average for the student.
* `letter_grade`: returns the letter grade based on their average.
* `passed?`: returns true if the student received a passing grade.
* `to_s`: returns the student's name, grade average, and letter grade in a single string.

## Sample Usage

```ruby
student = Student.new('Lindsay', 'Weir', [95, 100, 92, 83])
student.full_name     # => 'Lindsay Weir'
student.grade_average # => 92.5
student.letter_grade  # => 'A'
student.passed?       # => true
puts student          # Outputs "Lindsay Weir, A (92.5)"


student = Student.new('Daniel', 'Desario', [42, 56, 0, 24])
student.full_name     # => 'Daniel Desario'
student.grade_average # => 30.5
student.letter_grade  # => 'F'
student.passed?       # => false
puts student          # Outputs "Daniel Desario, F (30.5)"
```
