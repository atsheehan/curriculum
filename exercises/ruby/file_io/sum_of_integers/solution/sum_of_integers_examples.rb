# Example 1

def sum(file_path)
  string = File.read(file_path)
  numbers = string.split
  sum = 0

  numbers.each do |number|
    sum += number.to_i
  end

  sum
end

# Example 2

def sum(file_path)
  numbers = File.read(file_path).split
  numbers.inject(0) { |sum, n| sum += n.to_i }
end
