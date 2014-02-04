require 'minitest/spec'
require 'minitest/autorun'

require_relative 'rightmost_occurrence'

describe "#rightmost_occurrence" do
  it "returns nil if no matches are found" do
    rightmost_occurrence('abc', 'x').must_equal nil
  end

  it "returns the correct index when is only character" do
    rightmost_occurrence('t', 't').must_equal 0
  end

  it "returns the correct index when is in middle of string" do
    rightmost_occurrence('cat dog', 'd').must_equal 4
  end

  it "returns the correct index when char occurs more than once" do
    rightmost_occurrence('cat dog tutu', 't').must_equal 10
  end

  it "is not case sensitive" do
    rightmost_occurrence('Sometimes I like yOu', 'o').must_equal 18
  end
end
