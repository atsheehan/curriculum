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

    capture_output do
      eval(code)
      expect($stdout.string).to eq expected_output
    end
  end
end

def capture_output(&block)
  original_stdout = $stdout
  $stdout = fake_stdout = StringIO.new
  original_stderr = $stderr
  $stderr = fake_stderr = StringIO.new

  begin
    yield
  ensure
    $stdout = original_stdout
    $stderr = original_stderr
  end

  [fake_stdout.string, fake_stderr.string]
end
