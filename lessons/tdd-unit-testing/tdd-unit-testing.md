Writing tests for an application before writing any other code is a very effective way to ensure our final product works correctly and to guide our development process. In this article we introduce **RSpec**, a testing framework for Ruby application.

### Learning Goals

* Create a class with a corresponding unit test
* Add a failing test and then implement the feature to make it pass
* Refactor code once there is a passing test suite
* Understand a few benefits of writing tests first

### How to Unit Test (with RSpec)

[RSpec](https://github.com/rspec/rspec) is one of several popular testing frameworks in the Ruby world. You can get started by installing RSpec directly with the following command:

```no-highlight
gem install rspec
```

When writing tests it is customary to have a separate corresponding **spec file** for every class file in your project. These spec files are called **unit tests** and they will focus on testing individual classes. Let's lay out an example of the convention for how we would set up an `Airplane` class and it's corresponding spec file:

```
.
├── lib
│   └── airplane.rb
└── spec
    └── lib
        └── airplane_spec.rb
```

Here we have two files: *airplane.rb* which will contain the class definition and *airplane_spec.rb* that will contain the tests for that class. Let's start with *airplane.rb* and provide a bare-bones definition for our class:

```ruby
class Airplane
end
```

In the *airplane_spec.rb* file we can layout the structure of our test suite:

```ruby
require_relative "../../lib/airplane"

describe Airplane do
end
```

First we load *airplane.rb* using `require_relative` so that we have access to the Airplane class. **describe** is an RSpec method that informs the test suite which class we're testing and provides a location for us to define our tests for this class.

### First Tests

The most common thing that we will want to write tests for on our ruby objects are methods. In our example of the Airplane class above we might want a `flying?` method that returns true or false depending on whether or not the airplane we are modeling is in the air.

We first create another describe block inside the describe for the `Airplane` class for our `flying?` method. We will want our `flying?` method to return true or false based on the current state of the aircraft. To illustrate this we will create two `context` blocks within our `#flying?` method block to clarify the different states we expect our aircraft to be in when we want to determine if it is flying or not. The final step in outlining our tests is to write an `it` block in which we will place our assertion about the behavior of the flying? method call on an Airplane object in each state. The string of text that follows this `it` call is simply a descriptor that explains what we expect the result of the method call to be.

Here is an example for the layout just described:

```ruby
require_relative "../../lib/airplane"

describe Airplane do
  describe '#flying?' do
    context 'when the plane is flying' do
      it 'returns true' do

      end
    end

    context 'when the plane is not flying' do
      it 'returns false' do

      end
    end
  end
end
```

To run this test suite we can use the `rspec` command while in our project folder:

```
$ rspec
..

Finished in 0.00103 seconds (files took 0.81355 seconds to load)
2 examples, 0 failures
```

We have two empty tests that are passing because we have not made any assertions. Empty it block assetions in rspec evaluate as passing tests until we add the code for them to test.

There are a lot of different comparison methods and tools that we will learn to use in RSpec but for now we will start with a simple equality comparison. Inside the `it` block of each test we will add the following line:

```ruby
it 'returns true' do
  expect(Airplane.new.flying?).to eq true
end

it 'returns false' do
  expect(Airplane.new.flying?).to eq false
end

```

Now when we run rspec we should see the following output:

```
$ rspec
FF

Failures:

  1) Airplane#flying? when the plane is flying returns true
     Failure/Error: expect(Airplane.new.flying?).to eq true
     NoMethodError:
       undefined method `flying?' for #<Airplane:0x007feee1efb9d8>
     # ./spec/lib/airplane_spec.rb:7:in `block (4 levels) in <top (required)>'

  2) Airplane#flying? when the plane is grounded returns false
     Failure/Error: expect(Airplane.new.flying?).to eq false
     NoMethodError:
       undefined method `flying?' for #<Airplane:0x007feee1efa4e8>
     # ./spec/lib/airplane_spec.rb:13:in `block (4 levels) in <top (required)>'

Finished in 0.00121 seconds (files took 0.61935 seconds to load)
2 examples, 2 failures

Failed examples:

rspec ./spec/lib/airplane_spec.rb:6 # Airplane#flying? when the plane is flying returns true
rspec ./spec/lib/airplane_spec.rb:12 # Airplane#flying? when the plane is grounded returns false
```

You will notice now that we have 2 failing tests and both tests are telling us `undefined method 'flying?'`, or in other words we haven't defined the `flying?` method on our Airplane class. Additionally we will also need some way of setting our airplane as flying or not when we create it.

If you want to challenge yourself see if you can come up with an implementation in your Airplane class to make both tests pass. As a hint once we make a way to set our Airplane state to either flying or not we will need to change our tests slightly to set up our airplanes in our tests, one to be flying and one to be not.

Here is an example solution for what this could look like:

```ruby
class Airplane
  def initialize(status)
    if status == 'flying'
      @flying = true
    else
      @flying = false
    end
  end

  def flying?
    @flying
  end
end
```

```ruby
require_relative "../../lib/airplane"

describe Airplane do
  describe '#flying?' do
    context 'when the plane is flying' do
      it 'returns true' do
        expect(Airplane.new('flying').flying?).to eq true
      end
    end

    context 'when the plane is not flying' do
      it 'returns false' do
        expect(Airplane.new('grounded').flying?).to eq false
      end
    end
  end
end
```

### Test, Code, Refactor Cycle

As we can see from this example above the workflow for using tests to drive the development of our code is to first write tests, then write the code that makes the tests past, and finally refactor that code to see if you can make it better. Then make sure to always run the tests again so that you know everything is working.

In the example above our initialize method seems like it might be a bit clunky so we could perform the following refactor.

```ruby
class Airplane
  def initialize(status)
    @flying = set(status)
  end

  def flying?
    @flying
  end

  private

  def set(status)
    status == 'flying'
  end
end
```

when we run our tests again we confirm the code is still behaving the same way.

```
$ spec
..

Finished in 0.00162 seconds (files took 0.61635 seconds to load)
2 examples, 0 failures
```

### Why Unit Test?

As you can see from the example above in the end it turns out that we end up with more code in our test file than we have in the implementation of our Airplane class. This is very often the case, and as an application grows the tests grow with it and become almost if not more valuable as the application itself. If the entire set of these written for a given program are all passing then whatever code that has been written to implement that program is working, however it works under the hood.

There are also several other things that may have become apparent as we thought through just writing these two initial basic tests. Before we even wrote the code for our Airplane class much less the code for our `flying?` method we thought through what the possible return values of that method could be and the state our class would need to be in to return those values.

One of the most valuable results of test driving our code is that we also were left with a tool (single command the verified our code worked as expected) that allowed us to change the internal structure of the code with confidence that we aren't breaking any expected behavior. As your applications grow and grow this becomes a more and more valuable tool. It saves untold amounts of time to let the computer check that every edge case and side possibility of how we expect to use our application code is working as expected.

### In Summary

**RSpec** is a testing framework that we can use to write **unit tests** in Ruby (in addition to other types of tests). Unit tests are typically used to test methods on individual classes rather than the functionality of the application as a whole.

All tests should be saved in the *spec* folder of a project. For each file containing a class there should be a corresponding file in the *spec* folder mirroring the filename but ending in *_spec.rb*.

To run a test suite, use the `rspec` command. This will run all test files in the *spec* directory that end in *_spec.rb*.

**Test-driven development** is the practice of writing tests for methods before defining the implementation of the method. Test-driven development forces you to think about how the class will be used before attempting to write any more code.

After the tests have been written and the implementation is passing, it is advisable to go back and **refactor** the code to clean it up and remove any duplication. After the refactor, re-run the test suite to ensure it did not break any existing functionality.
