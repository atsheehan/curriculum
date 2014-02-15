
def winner?(board)
  # rows
  board.each do |row|
    if row.count('x') == 3 || row.count('o') == 3
      return true
    end
  end

  # columns
  board.transpose.each do |col|
    if col.count('x') == 3 || col.count('o') == 3
      return true
    end
  end

  # diagonals
  diags = [[board[0][0], board[1][1], board[2][2]],
           [board[0][2], board[1][1], board[2][0]]]
  diags.each do |diag|
    if diag.count('x') == 3 || diag.count('o') == 3
      return true
    end
  end
end

# Faizaan's solution

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
