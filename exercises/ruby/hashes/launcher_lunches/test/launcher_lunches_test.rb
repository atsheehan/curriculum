require 'minitest/spec'
require 'minitest/autorun'

require_relative '../lib/launcher_lunches'

describe 'launcher lunches' do
  it 'returns most expensize item' do
    most_expensive.must_equal "Veggie surprise bag from Adam's Veggie Express"
  end

  it 'returns the cost of ordering one of everything' do
    one_of_everything_from("Adam's Veggie Express").must_equal 23.42
    one_of_everything_from("Sam's Sandwhiches").must_equal     23.72
    one_of_everything_from("Eric's Emo Eats").must_equal       19.41
  end

  it 'estimates total number of eggs needed for the month (30 days)' do
    # 2 eggs used per menu item, on average 8 items sold per hour of operation
    monthly_egg_count.must_equal 10080
  end

  it 'lists all items for lactose intolerant individuals by price' do
    lactose_free_items.must_equal [:corn_on_the_cob, :sad_cereal, :apathetic_eggs, :mopey_falafels, :fluffer_nutter_with_bacon, :veggie_surprise_bag]
  end
end
