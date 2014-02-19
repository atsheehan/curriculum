require 'minitest/spec'
require 'minitest/autorun'

require_relative '../lib/shakespeare'

describe "#word_frequency" do
  it "outputs the frequency that each word appears" do
    frequency = word_frequency('hamlet.txt')
    frequency["bernardo"].must_equal 30
    frequency["jelly"].must_equal 1
    frequency["excellent"].must_equal 10
  end
end
