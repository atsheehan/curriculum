def multiply_lists(lists)
  first, second = lists.split("|")
  first_array = first.split(' ')
  second_array = second.split(' ')
  if first_array.length == second_array.length
    output = []
    first_array.each_with_index do |num, i|
      output << num.to_i * second_array[i].to_i
    end
    output.join(" ")
  else
    "Lists must be same length"
  end
end
