require_relative 'assignment'
require_relative 'student'
require_relative 'grade'

require "csv"

assignments = []
students = []
grades = []

# create assignment, student, and grade objects from CSV
filename = File.dirname(__FILE__) + "/grades.csv"

CSV.foreach(filename, headers: true, header_converters: :symbol) do |row|

  # find or create assignments
  assignment = assignments.find { |a| a.name == row[:assignment] }
  if assignment.nil?
    assignment = Assignment.new(
      row[:assignment],
      row[:due_date]
    )
    assignments << assignment

    puts "Created assignment: #{assignment.name}"
  else
    puts "Found assignment: #{assignment.name}"
  end

  # find or create student
  student = students.find { |s| s.name == row[:student_name] }
  if student.nil?
    student = Student.new(row[:student_name])
    students << student

    puts "Created student: #{student.name}"
  else
    puts "Found student: #{student.name}"
  end

  # find or create grade
  grade = grades.find { |g| g.student == student && g.assignment == assignment }

  if grade.nil?
    grade = Grade.new(
      assignment,
      student,
      row[:grade].to_i
    )
    grades << grade

    # associate the grade with its assignment and student
    assignment.grades << grade
    student.grades << grade

    puts "Recorded grade for #{grade.student.name} on #{grade.assignment.name}"
  else
    puts "Already recorded grade."
  end
end

# output reports

puts "\n\nAssignments:\n\n"
assignments.each do |assignment|
  puts assignment.report + "\n\n"
end

puts "Students:"
students.each do |student|
  puts student.report_card + "\n"
end
