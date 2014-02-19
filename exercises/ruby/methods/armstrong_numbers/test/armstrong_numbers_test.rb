require 'minitest/spec'
require 'minitest/autorun'

require_relative '../lib/armstrong_numbers'

describe "#armstrong_number?" do
  it "correctly identifies armstrong numbers of length 1" do
    0.upto(9) do |n|
      armstrong_number?(n).must_equal true
    end
  end

  it "correctly identifies non-armstrong numbers of length 2" do
    skip
    10.upto(99) do |n|
      armstrong_number?(n).must_equal false
    end
  end

  it "correctly identifies armstrong numbers of length 3" do
    skip
    armstrong_number?(153).must_equal true
    armstrong_number?(370).must_equal true
    armstrong_number?(371).must_equal true
  end

  it "correctly identifies non-armstrong numbers of length 3" do
    skip
    armstrong_number?(302).must_equal false
    armstrong_number?(404).must_equal false
    armstrong_number?(500).must_equal false
  end

  it "correctly identifies armstrong numbers of length 5" do
    skip
    armstrong_number?(54748).must_equal true
    armstrong_number?(92727).must_equal true
    armstrong_number?(93084).must_equal true
  end

  it "correctly identifies non-armstrong numbers of length 5" do
    skip
    armstrong_number?(30278).must_equal false
    armstrong_number?(40465).must_equal false
    armstrong_number?(50035).must_equal false
  end
end
