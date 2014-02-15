def uniques(list)
  uniques = []
  numbers = list.split(',')
  last = ""
  numbers.each do |number|
    if last != number
      uniques << number
      last = number
    end
  end
  uniques.join(",")
end

# Faizaan's solution

def uniques(list)
  list = list.split(',')
  recent = nil
  unique = []
  list.each do |number|
    if number != recent
      unique << number
      recent = number
    end
  end
  unique.join(',')
end
