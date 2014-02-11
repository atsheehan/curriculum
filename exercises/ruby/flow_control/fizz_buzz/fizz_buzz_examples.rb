# Example 1

i = 1
while i <= 100
  if (i % 5 == 0) && (i % 3 == 0)
    puts "FizzBuzz"
  elsif i % 5 == 0
    puts "Buzz"
  elsif i % 3 == 0
    puts "Fizz"
  else
    puts i
  end

  i += 1
end

# Example 2

i = 1
while i <= 100
  if (i % 15 == 0)
    puts "FizzBuzz"
  elsif i % 5 == 0
    puts "Buzz"
  elsif i % 3 == 0
    puts "Fizz"
  else
    puts i
  end

  i += 1
end

# Example 3

(1..100).each do |i|
  if (i % 15 == 0)
    puts "FizzBuzz"
  elsif i % 5 == 0
    puts "Buzz"
  elsif i % 3 == 0
    puts "Fizz"
  else
    puts i
  end
end

# Example 4

(1..100).each do |i|
  if i.modulo(15) == 0
    puts "FizzBuzz"
  elsif i.modulo(5) == 0
    puts "Buzz"
  elsif i.modulo(3) == 0
    puts "Fizz"
  else
    puts i
  end
end
