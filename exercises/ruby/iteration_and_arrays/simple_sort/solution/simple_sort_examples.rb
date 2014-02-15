# Many soting algorithms can be found at:
# http://rosettacode.org/wiki/Sorting_algorithms

# bubble sort
def sort_list(list)
  numbers = list.split(" ").map(&:to_f)

  numbers.length.times do |j|
    for i in 1...(numbers.length - j)
      if numbers[i] < numbers[i - 1]
        numbers[i], numbers[i - 1] = numbers[i - 1], numbers[i]
      end
    end
  end
  numbers.join(" ")
end

## Faizaan's solution

def sort_list(list)
  list = list.split(' ').map(&:to_f)
  list = merge_sort(list).map(&:inspect).join(' ')
end


def merge_sort(list)
  return list if list.length <= 1

  middle = list.length / 2
  left = list[0,middle]
  right = list[middle..-1]

  left = merge_sort(left)
  right = merge_sort(right)
  merge(left, right)
end

def merge(left, right)
  result = []
  until left.empty? || right.empty?
    if left.first <= right.first
      result << left.shift
    else
      result << right.shift
    end
  end
  result + left + right
end
