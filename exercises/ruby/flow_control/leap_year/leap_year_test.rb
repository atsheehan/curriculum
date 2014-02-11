require 'minitest/spec'
require 'minitest/autorun'

require_relative 'leap_year'

describe "#leap_year?" do
  it "identifies year is a leap year" do
    leap_year?(2016).must_equal true
  end

  it "identifies year is not a leap year" do
    skip "Fix me when ready!"
    leap_year?(2014).must_equal false
  end

  it "identifies when century is not a leap year" do
    skip "Fix me when ready!"
    leap_year?(2100).must_equal false
  end

  it "identifies when century is a leap year" do
    skip "Fix me when ready!"
    leap_year?(2000).must_equal true
  end
end
