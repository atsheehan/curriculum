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

def multiply_lists(lists)
  num_arrays = lists.split("|").map{|a| a.split(' ').map(&:to_i) }
  if num_arrays[0].length == num_arrays[1].length
    num_arrays[0].zip(num_arrays[1]).map{|nums| nums.reduce(:*) }.join(" ")
  else
    "Lists must be same length"
  end
end

# Faizaan's solution

def multiply_lists(lists)
  lists = lists.split('|').map(&:strip)
  list_a = lists[0].split(' ')
  list_b = lists[1].split(' ')
  validate_lists(list_a, list_b)
  product_of_lists(list_a, list_b)
end

def validate_lists(list_a, list_b)
  unless list_a.length == list_b.length
    puts 'Lists must be same length'
    exit
  end
end

def product_of_lists(list_a, list_b)
  product_list = []
  list_a.each_with_index do |num_a, i|
    x = num_a.to_i * list_b[i].to_i
    product_list << x
  end
  product_list
end
