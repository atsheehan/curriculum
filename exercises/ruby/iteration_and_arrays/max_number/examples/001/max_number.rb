def max_number(numbers)
  max = numbers.first

  numbers.each do |num|
    if num > max
      max = num
    end
  end

  max
end
