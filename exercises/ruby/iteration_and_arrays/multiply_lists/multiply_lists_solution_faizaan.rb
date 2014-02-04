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
