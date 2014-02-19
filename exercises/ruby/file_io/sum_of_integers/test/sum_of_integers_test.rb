require 'minitest/spec'
require 'minitest/autorun'

require_relative '../lib/sum_of_integers'

describe "#sum" do
  it "sums up a file of integers" do
    sample_file = File.join(File.dirname(__FILE__), 'integers.txt')
    sum(sample_file).must_equal 55
  end
end
