require_relative '../lib/evens'

describe 'evens' do
  it 'return an array of even numbers' do
    input = [1,2,3,9,3,2,0,-5,-4,2]
    output = evens(input)
    expect(output).to eq [2,2,0,-4,2]
  end
end
