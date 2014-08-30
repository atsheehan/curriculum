require_relative '../lib/student'

describe Student do

  describe 'student name' do
    let(:student) { Student.new('Ferris', 'Bueller', [0, 0, 0, 0]) }

    describe '#first_name' do
      it 'reports the students first name' do
        expect(student.first_name).to eq('Ferris')
      end
    end

    describe '#last_name' do
      it 'reports the students last name' do
        expect(student.last_name).to eq('Bueller')
      end
    end

    describe '#full_name' do
      it 'combines the first and last names' do
        expect(student.full_name).to eq('Ferris Bueller')
      end
    end
  end

  describe 'student grades' do
    let(:tolerance) { 0.0001 }

    describe '#grade_average' do
      it 'calculates the average grade for a student' do
        student = Student.new('Bob', 'Loblaw', [80, 90, 100])
        expect(student.grade_average).to be_within(tolerance).of(90.0)
      end

      it 'correctly handles fractions of a grade' do
        student = Student.new('Bob', 'Loblaw', [91, 89, 75, 98])
        expect(student.grade_average).to be_within(tolerance).of(88.25)
      end

      it 'returns zero when no grades are available' do
        student = Student.new('Ferris', 'Bueller', [])
        expect(student.grade_average).to be_within(tolerance).of(0.0)
      end
    end

    describe '#letter_grade' do
      it 'assigns an A grade to averages 90.0 or above' do
        students = [
          Student.new('Bob', 'Loblaw', [90, 90, 90]),
          Student.new('Barry', 'Zuckerkorn', [95, 95, 95]),
          Student.new('Buster', 'Bluth', [100, 100, 100])
        ]

        students.each do |student|
          expect(student.letter_grade).to eq('A')
        end
      end

      it 'assigns an B grade to averages 80.0 <= avg < 90.0' do
        students = [
          Student.new('Bob', 'Loblaw', [80, 80, 80]),
          Student.new('Barry', 'Zuckerkorn', [81, 83, 89]),
          Student.new('Buster', 'Bluth', [89.9, 89.9, 89.9])
        ]

        students.each do |student|
          expect(student.letter_grade).to eq('B')
        end
      end

      it 'assigns an C grade to averages 70.0 <= avg < 80.0' do
        students = [
          Student.new('Bob', 'Loblaw', [70, 70, 70]),
          Student.new('Barry', 'Zuckerkorn', [71, 73, 79]),
          Student.new('Buster', 'Bluth', [79.9, 79.9, 79.9])
        ]

        students.each do |student|
          expect(student.letter_grade).to eq('C')
        end
      end

      it 'assigns an D grade to averages 60.0 <= avg < 70.0' do
        students = [
          Student.new('Bob', 'Loblaw', [60, 60, 60]),
          Student.new('Barry', 'Zuckerkorn', [61, 63, 69]),
          Student.new('Buster', 'Bluth', [69.9, 69.9, 69.9])
        ]

        students.each do |student|
          expect(student.letter_grade).to eq('D')
        end
      end

      it 'assigns an F grade to averages below 60.0' do
        students = [
          Student.new('Bob', 'Loblaw', [30, 40, 50]),
          Student.new('Barry', 'Zuckerkorn', [0, 0, 0]),
          Student.new('Buster', 'Bluth', [59.9, 59.9, 59.9])
        ]

        students.each do |student|
          expect(student.letter_grade).to eq('F')
        end
      end
    end

    describe '#passed?' do
      it 'is true if the letter grade is not an F' do
        student = Student.new('Bob', 'Loblaw', [60, 60, 60])
        expect(student.passed?).to eq(true)
      end

      it 'is false if the student has a F letter grade' do
        student = Student.new('Ferris', 'Bueller', [50, 50, 50])
        expect(student.passed?).to eq(false)
      end
    end
  end

  describe 'reporting' do
    describe '#to_s' do
      it 'prints student name, grade average, and letter grade' do
        student = Student.new('Bob', 'Loblaw', [75, 85, 95])
        expect(student.to_s).to eq('Bob Loblaw, B (85.0)')
      end
    end
  end
end
