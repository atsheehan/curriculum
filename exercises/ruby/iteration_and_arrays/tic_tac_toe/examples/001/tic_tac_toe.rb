def winner?(board)
  test_linear(board) || test_linear(board.transpose)
end

def elements_equal?(array)
  return false if array.include?(" ")
  array.uniq.length == 1
end

def test_linear(board)
  diagonal_1 = []
  diagonal_2 = []
  result = false

  board.each_with_index do |row, i|
    result = true if elements_equal?(row)
    diagonal_1 << row[i]
    diagonal_2 << row[-(i+1)]
  end

  result = true if elements_equal?(diagonal_1) || elements_equal?(diagonal_2)

  result
end
