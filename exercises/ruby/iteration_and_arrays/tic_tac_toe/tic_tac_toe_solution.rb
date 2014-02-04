
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
