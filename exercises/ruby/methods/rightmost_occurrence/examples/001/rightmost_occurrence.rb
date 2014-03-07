def rightmost_occurrence(string, char)
  index = nil
  string.chars.each_with_index do |c, i|
    index = i if c.downcase == char
  end
  index
end
