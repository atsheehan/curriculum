# Example 1

i = 1
while i <= 100
  puts i if (i % 2 != 0)
  i += 1
end

# Example 2

for i in 1..100
  puts i if (i % 2 != 0)
end

# Example 3

i = 1
until i > 100
  puts i if (i % 2 != 0)
  i += 1
end

# Exmaple 4

100.times do |i|
  puts i if (i % 2 != 0)
end

# Example 5

(1..100).each do |i|
  puts i if (i % 2 != 0)
end
