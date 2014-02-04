require 'minitest/spec'
require 'minitest/autorun'

require_relative './tic_tac_toe'

describe 'tic tac toe' do
  it 'finds horizontal winners' do
    input = [['x', 'x', 'x'],
             [' ', ' ', ' '],
             [' ', ' ', ' ']]

    winner?(input).must_equal true
  end

  it 'finds vertical winners' do
    skip
    input = [['o', ' ', ' '],
             ['o', ' ', ' '],
             ['o', ' ', ' ']]

    winner?(input).must_equal true
  end

  it 'finds diagonal winners' do
    skip
    input1 = [['x', ' ', ' '],
              [' ', 'x', ' '],
              [' ', ' ', 'x']]

    input2 = [[' ', ' ', 'o'],
              [' ', 'o', ' '],
              ['o', ' ', ' ']]

    winner?(input1).must_equal true
    winner?(input2).must_equal true
  end
end
