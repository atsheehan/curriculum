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
