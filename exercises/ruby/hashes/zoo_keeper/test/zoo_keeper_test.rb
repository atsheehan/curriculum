require 'minitest/spec'
require 'minitest/autorun'

require_relative '../lib/zoo_keeper'

describe 'earn hash methods' do
  # this before block makes the @animals hash
  # available in all of the tests
  before do
    @animals = {
      'leopard'   => 1,
      'gorilla'   => 3,
      'hippo'     => 4,
      'zebra'     => 1,
      'lion'      => 2,
      'eagle'     => 3,
      'ostrich'   => 2,
      'alligator' => 6
    }
  end

  it 'returns a hash with only animals that start with vowels' do
    output = starts_with_vowel(@animals)

    output.must_include 'eagle'
    output.must_include 'ostrich'
    output.must_include 'alligator'
    output.wont_include 'zebra'
  end

  it 'returns a hash containing only lonely animals' do
    output = lonely_animals(@animals)

    output.must_include 'leopard'
    output.must_include 'zebra'
    output.wont_include 'hippo'
  end

  it 'returns a count of the total number of animals' do
    #this method can return a count
    total_animals(@animals).must_equal 22
  end

  it 'returns a hash with newly added animals' do
    # the add_new_animals method should only add animals
    # if there are none of that type of animal already at the zoo
    # (the animals are very territorial)
    new_shipment = {
      'hippo' => 2,
      'panda' => 4,
      'tiger' => 3,
      'eagle' => 5
    }

    output = add_new_animals(@animals, new_shipment)

    output['hippo'].must_equal 4
    output['panda'].must_equal 4
    output['tiger'].must_equal 3
    output['eagle'].must_equal 3
  end

  it 'returns a hash with animals grouped by count' do
    output = group_by_count(@animals)

    output[6].must_include 'alligator'
    output[2].must_include 'ostrich'
    output[2].must_include 'lion'
  end
end
