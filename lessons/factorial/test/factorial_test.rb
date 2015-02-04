require_relative '../lib/factorial'

describe "Factorial" do
  it "calculates the factorial of 1" do
    expect(factorial(1)).to eq 1
  end

  it "calculates the factorial of 2" do
    expect(factorial(2)).to eq 2
  end

  it "calculates the factorial of 3" do
    expect(factorial(3)).to eq 6
  end

  it "calculates the factorial of 4" do
    expect(factorial(4)).to eq 24
  end

  it "calculates the factorial of 5" do
    expect(factorial(5)).to eq 120
  end

  it "calculates the factorial of 0" do
    expect(factorial(0)).to eq 1
  end
end
