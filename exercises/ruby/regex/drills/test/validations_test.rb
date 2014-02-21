require 'minitest/spec'
require 'minitest/autorun'

require_relative '../lib/validations.rb'

describe '#valid_email?' do
  it 'validates a valid email (something@something.com)' do
    assert(valid_email?('test@test.com'))
    assert(valid_email?('test@test.co.uk'))
  end
  it 'does not validate an invalid email' do
    skip
    refute(valid_email?('test'))
    refute(valid_email?('test@test'))
  end
end

describe '#valid_phone_number?' do
  it 'validates a valid US phone number (10 numbers long)' do
    skip
    assert(valid_phone_number?('1234567890'))
  end
  it 'does not validate an invalid phone number' do
    skip
    refute(valid_phone_number?('123456789'))
    refute(valid_phone_number?('not a phone number'))
  end
  it 'validates a phone number with () and - ((123)-456-7890)' do
    skip
    assert(valid_phone_number?('(123)-456-7890'))
    assert(valid_phone_number?('123-456-7890'))
  end
end

describe '#valid_password?' do
  it 'validates a valid password (at least 1 number, no spaces and at least 8 characters long' do
    skip
    assert(valid_password?('password30'))
    assert(valid_password?('password1'))
  end
  it 'does not validate an invalid password' do
    skip
    refute(valid_password?('password space'))
    refute(valid_password?('pass'))
  end
end

describe '#valid_username?' do
  it 'validates a valid username (at least 1 letter, only letters, digits and underscores)' do
    skip
    assert(valid_username?('abc123'))
    assert(valid_username?('test'))
  end
  it 'does not validate an invalid username' do
    skip
    refute(valid_username?('123456'))
    refute(valid_username?('my_name!'))
  end
end

describe '#valid_credit_card_number?' do
  it 'validates a valid credit card (13, 15 or 16 digits long, starts with a 3, 4, 5 or 6 and contains only digits' do
    skip
    assert(valid_credit_card_number?('4111111111111111'))
    assert(valid_credit_card_number?('371449635398431'))
  end
  it 'does not validate an invalid credit card number' do
    skip
    refute(valid_credit_card_number?('abc'))
    refute(valid_credit_card_number?('271449635398431'))
    refute(valid_credit_card_number?('51234567890123'))
  end
end

describe '#only_numbers?' do
  it 'returns true if only digits are passed in' do
    skip
    assert(only_numbers?('1'))
    assert(only_numbers?('123'))
  end
  it 'return false if anything other than a digit is passed in' do
    skip
    refute(only_numbers?('a12'))
    refute(only_numbers?('abc'))
  end
end

describe '#only_letters?' do
  it 'returns true if only letters are passed in' do
    skip
    assert(only_letters?('abc'))
    assert(only_letters?('test'))
  end
  it 'returns false if anything other than a letter is passed in' do
    skip
    refute(only_letters?('ab2'))
    refute(only_letters?('123'))
  end
end

describe '#valid_social_security?' do
  it 'validates a valid social (9 numbers)' do
    skip
    assert(valid_social_security?('123456789'))
  end
  it 'does not validate an invalid social' do
    skip
    refute(valid_social_security?('abcd12345'))
    refute(valid_social_security?('12345678'))
    refute(valid_social_security?('123456789b'))
  end
  it 'validates a social that has dashes (123-45-6789)' do
    skip
    assert(valid_social_security?('123-45-6789'))
  end
end

describe '#valid_zipcode?' do
  it 'validates a 5 digit zip code (02111)' do
    skip
    assert(valid_zip_code?('12345'))
    assert(valid_zip_code?('21301'))
  end
  it 'does not validate an invalid zip code' do
    skip
    refute(valid_zip_code?('abc'))
    refute(valid_zip_code?('0123'))
  end
  it 'validates a 9 digit zip code (02111-1234)' do
    skip
    assert(valid_zip_code?('02111-1234'))
  end
end
