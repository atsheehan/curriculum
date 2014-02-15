require 'minitest/spec'
require 'minitest/autorun'

require_relative '../lib/common_words'

describe 'common words' do
  it 'returns most common word' do
    input = 'a short list of words with some words'

    most_common(input).must_include 'words'
  end

  it 'ignores case of letters and punctuation when return most common word' do
    input = 'Words in a short, short words list of words!'

    most_common(input).must_include 'words'
    most_common(input).wont_include 'short'
  end

  it 'returns most common words if there are ties' do
    input = 'a short list of words with some short words in it'

    most_common(input).must_include 'words'
    most_common(input).must_include 'short'
  end
end
