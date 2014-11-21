require_relative '../lib/badwords'

describe 'badwords' do
  it 'returns a string with appopriately replaced words' do
    input = "It is doubtful because I tend to ignore such incorrect statements."
    output = badwords(input)
    expect(output).to eq "It is ---- because I tend to ---- such ---- statements."
  end

  it 'allows for punctuation' do
    input "That is incorrect. Please ignore what they said."
    output = badwords(input)
    expect(output).to eq "That is ----. Please ---- what they said."
  end
end
