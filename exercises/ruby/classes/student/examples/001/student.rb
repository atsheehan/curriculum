class Student

  def initialize(first_name, last_name, grades)
    @first_name = first_name
    @last_name = last_name
    @grades = grades
  end

  def first_name
    @first_name
  end

  def last_name
    @last_name
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def grade_average
    return 0.0 if @grades.empty?

    sum = 0

    @grades.each do |grade|
      sum += grade
    end

    sum / @grades.length.to_f
  end

  def letter_grade
    if grade_average >= 90.0
      'A'
    elsif grade_average >= 80.0
      'B'
    elsif grade_average >= 70.0
      'C'
    elsif grade_average >= 60.0
      'D'
    else
      'F'
    end
  end

  def passed?
    letter_grade != 'F'
  end

  def to_s
    "#{full_name}, #{letter_grade} (#{grade_average})"
  end
end
