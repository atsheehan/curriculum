require 'minitest/spec'
require 'minitest/autorun'

require_relative 'sum_of_integers'

describe "#sum" do
  it "sums up a file of integers" do
    sum('integers.txt').must_equal 55
  end
end
