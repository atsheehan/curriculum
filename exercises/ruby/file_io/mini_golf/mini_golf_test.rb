require 'minitest/spec'
require 'minitest/autorun'

require_relative 'mini_golf'

describe "#display_scores" do
  it "displays the scores in the correctly" do
    expected_output = <<-eos
Mini Golf Scores

1. Eric with 21 strokes.
2. Helen with 22 strokes.
3. Dan with 26 strokes.
4. Jason with 27 strokes.
5. Adam with 27 strokes.
6. Sam with 30 strokes.
7. Bill with 31 strokes.
8. Evan with 32 strokes.
9. Faizaan with 79 strokes.
    eos

    proc { display_scores('scores.csv') }.must_output expected_output
  end
end
