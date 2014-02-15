require 'minitest/spec'
require 'minitest/autorun'

require_relative './morse_code'

describe 'morse code' do
  it 'decodes a secret morse code message' do
    code = '.... . .-.. .--. / .. .----. -- / - .-. .- .--. .--. . -.. / .. -. / - .... . / -.-. --- -- .--. ..- - . .-. -.-.-- / - .... . / .--. .- ... ... .-- --- .-. -.. / .. ... / ...-- ..--- ..... ---.. ----.'

    decode(code).must_equal "HELP I'M TRAPPED IN THE COMPUTER! THE PASSWORD IS 32589"
  end
end

