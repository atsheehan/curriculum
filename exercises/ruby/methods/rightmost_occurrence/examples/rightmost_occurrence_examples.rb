# Example 1

def rightmost_occurrence(string, char)
  index = nil
  string.chars.each_with_index do |c, i|
    index = i if c.downcase == char
  end
  index
end

# Example 2

def rightmost_occurrence(string, char)
  reverse_index = string.reverse.downcase.index(char)

  if reverse_index
    (string.length - 1) - reverse_index
  else
    nil
  end
end
