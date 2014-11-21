require_relative '../lib/rap-stars'

describe 'rap-star methods' do
  it 'returns an array of the full names of rappers' do
    input = [{first: "Tupac", last: "Shakur"}, {first: "Snoop", last: "Dogg"}]
    output = names(input)
    expect(output).to eq ["Tupac Shakur", "Snoop Dogg"]
  end

  it 'returns an array of hashes containing rapper full names and their email addresses' do
    input = [{first: "Tupac", last: "Shakur", domain: "google.com"}, {first: "Snoop", last: "Dogg", domain: "yahoo.com"}]
    output = emails(input)
    expect(output).to eq ["tupac.shakur@gmail.com", "snoop.dogg@yahoo.com"]
  end

  it 'returns the average age of all rappers to as a float to a single decimal' do
    input = [{first: "Tupac", last: "Shakur", age: 20}, {first: "Snoop", last: "Dogg", age: 30}]
    output = age(input)
    expect(output).to eq 25.0
  end

  it 'returns the average weight of all rappers to as a float to a single decimal' do
    input = [{first: "Tupac", last: "Shakur", weight: 200}, {first: "Snoop", last: "Dogg", age: 180}]
    output = weight(input)
    expect(output).to eq 190.0
  end

end
