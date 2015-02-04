require_relative '../lib/fibonacci'

describe "Fibonacci" do
  it "calculates the 1st item in the series" do
    expect(fibonacci(1)).to eq 1
  end

  it "calculates the 2nd item in the series" do
    expect(fibonacci(2)).to eq 1
  end

  it "calculates the 3rd item in the series" do
    expect(fibonacci(3)).to eq 2
  end

  it "calculates the 4th item in the series" do
    expect(fibonacci(4)).to eq 3
  end

  it "calculates the 5th item in the series" do
    expect(fibonacci(5)).to eq 5
  end

  it "calculates the 6th item in the series" do
    expect(fibonacci(6)).to eq 8
  end

  it "calculates the 7th item in the series" do
    expect(fibonacci(7)).to eq 13
  end

  it "calculates the 8th item in the series" do
    expect(fibonacci(8)).to eq 21
  end

  it "calculates the 15th item in the series" do
    expect(fibonacci(15)).to eq 610
  end
end
