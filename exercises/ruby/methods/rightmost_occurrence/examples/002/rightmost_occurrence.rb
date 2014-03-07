def rightmost_occurrence(string, char)
  reverse_index = string.reverse.downcase.index(char)

  if reverse_index
    (string.length - 1) - reverse_index
  else
    nil
  end
end
