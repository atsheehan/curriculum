require 'minitest/spec'
require 'minitest/autorun'

require_relative '../lib/distance_between_points'

describe "#distance" do
  it "finds the distance between two points that are the same" do
    point1 = [0, 0]
    point2 = [0, 0]

    distance(point1, point2).must_equal 0
  end

  it "finds the distance between two points" do
    skip
    point1 = [0, 0]
    point2 = [3, 0]

    distance(point1, point2).must_equal 3
  end

  it "finds the distance between points with negative" do
    skip
    point1 = [0, 0]
    point2 = [-5, 0]

    distance(point1, point2).must_equal 5
  end

  it "rounds the distance to 3 decimal places" do
    skip
    point1 = [0, 0]
    point2 = [-3, 1]

    distance(point1, point2).must_equal 3.162
  end
end
