require_relative '../lib/numvowels'

describe 'numvowels' do
  it 'correctly returns the number of vowels in a string' do
    input = "I wonder how many vowels this sentence has."
    output = numvowels(input)
    expect(output).to eq 12
  end
end
