# Example 1

def armstrong_number?(num)
  power = num.to_s.length
  sum = 0

  num.to_s.chars.each do |char|
    sum += char.to_i ** power
  end

  sum == num
end

# Example 2

def armstrong_number?(num)
  power = num.to_s.length
  digits = num.to_s.chars.map(&:to_i)
  sum = digits.inject(0) { |sum, d| sum += d ** power }
  sum == num
end
