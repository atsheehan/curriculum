require 'minitest/spec'
require 'minitest/autorun'

require_relative '../lib/odd_numbers'

describe "Odd Numbers" do
  it "prints all odd numbers from 1 to 100" do
    expected_output = <<-eos
1
3
5
7
9
11
13
15
17
19
21
23
25
27
29
31
33
35
37
39
41
43
45
47
49
51
53
55
57
59
61
63
65
67
69
71
73
75
77
79
81
83
85
87
89
91
93
95
97
99
    eos

    code = File.read(File.join(File.dirname(__FILE__), '../lib/odd_numbers.rb'))
    proc { eval(code) }.must_output expected_output
  end
end
