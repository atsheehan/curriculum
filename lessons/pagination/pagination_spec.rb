require 'rspec'
require_relative './pagination'

describe '#paginate' do
  let(:results_per_page) { 10 }
  let(:max_pages) { 10 }

  it 'should return an array' do
    pages = paginate(1, 100, results_per_page, max_pages)
    expect(pages).to be_an(Array)
  end

  it 'should return 1-3 if there are 30 results' do
    pages = paginate(1, 30, results_per_page, max_pages)
    expect(pages).to eq([1, 2 ,3])
  end

  it 'should return an array with values 1-9' do
    pages = paginate(1, 200, results_per_page, max_pages)
    expect(pages).to eq([1, 2, 3, 4, 5, 6, 7, 8, 9])
  end

  it 'should return an array with values 2-10' do
    pages = paginate(6, 200, results_per_page, max_pages)
    expect(pages).to eq([2, 3, 4, 5, 6, 7, 8, 9, 10])
  end
end
