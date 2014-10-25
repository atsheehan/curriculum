require_relative "guess_number"

MAX_VALUE = 300000000
MAX_TRIES = Math.log2(MAX_VALUE).ceil

hidden = rand(MAX_VALUE) + 1
checks_called = 0

define_method :check do |guess|
  checks_called += 1

  if checks_called > MAX_TRIES + 1
    raise "check called too many times"
  end

  if guess > hidden
    1
  elsif guess < hidden
    -1
  else
    0
  end
end

guess = guess_number(1, MAX_VALUE)

if guess == hidden
  puts "Guessed correctly!"
  exit 0
else
  puts "Incorrect guess."
  exit 1
end
