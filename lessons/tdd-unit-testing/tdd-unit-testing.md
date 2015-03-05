## Unit Testing and TDD

### How to Unit Test (with rspec)

#### Initial Settup
[Rspec](https://github.com/rspec/rspec) is one of several popular testing
frameworks in the Ruby world. You can get started by adding `'rspec'` to your
Gemfile in whatever project you are working on (sinatra or rails). The Rspec
Github homepage has useful information for setting up your project with Rspec
but our own `'make_it_so'` gem also generates either a Rails or Sinatra project
with Rspec already in the gemfile and the needed folders ready to go.

Once you have rspec added to your project it is customary to have a seperate
corrosponding spec file for every class file in your project. These spec files
are called Unit tests and they will focus on testing individual classes. Let me
lay out an example of the convention for how I would set up an `Airplane` class
and it's corrosponding spec file.

```
<appname>\lib\airplane.rb
<appname>\spec\lib\airplane_spec.rb
```

Those files should contain the following basic pieces.

```ruby
<appname>\lib\airplane.rb

class Airplane

end
```

```ruby
require 'spec_helper'

describe Airplane do

end
```

The `describe` is a method call to the Rspec library and passing that the class
name `Airplane` tells Rspec to look for a class `Airplane` in the matching
folder/filename structure elsewhere in your project. We will write our tests for
the class Airplane in the block being passed to that describe.

#### First Tests

The most common thing that we will want to write tests for on our ruby objects
are methods. In our example of the Airplane class above we might want a
`flying?` method that returns true or false depending on whether or not the
airplane we are modeling is in the air.

We first create another describe block inside the describe for the `Airplane`
class for our `flying?` method. We will want our `flying?` method to return true
or false based on the current state of the aircraft. To illustrate this we will
create two `context` blocks within our `#flying?` method block to clarify the
different states we expect our aircraft to be in when we want to determine if it
is flying or not. The final step in outlining our tests is to write an `it`
block in which we will place our assertion about the behavior of the flying?
method call on an Airplane object in each state. The string of text that follows
this `it` call is simply a descriptor that explains what we expect the result of
the method call to be.

Here is an example for how we layout what I just described. 

```ruby
require 'spec_helper'

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

If we run `$ rspec` in a command prompt inside our project folder we should now
see the following output but we still haven't made any assertions about our
code, or written our failing tests yet. Empty it block assetions in rspec
evaluate as passing tests until we add the code for them to test.

```
$ rspec
..

Finished in 0.00103 seconds (files took 0.81355 seconds to load)
2 examples, 0 failures
```

There is a lot of different comparison methods and tools that we will learn to
use in Rspec but for now we will start with a simple equality comparison. Inside
the `it` block of each test we will add the following line:

```ruby
it 'returns true' do
  expect(Airplane.new.flying?).to eq true
end

it 'returns false' do
  expect(Airplane.new.flying?).to eq false
end

```

Now when we run rspec we should see the following output.

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

You will notice now that we have 2 failing tests and both tests are telling us
`undefined method 'flying?'`, or in other words we haven't defined the `flying?`
method on our Airplane class. Additionally we will also need some way of setting
our airplane as flying or not when we create it.

If you want to challenge yourself see if you can come up with an implementation
in your Airplane class to make both tests pass. As a hint once we make a
way to set our Airplane state to either flying or not we will need to change our
tests slightly to set up our airplanes in our tests, one to be flying and one to
be not.

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

#### Test, Code, Refactor lifecycle

As you can see from this example above the workflow for using tests to drive the
development of your code is to first write tests, then write the code that makes
the tests past, and finally refactor that code to see if you can make it better.
Then make sure to always run the tests again so that you know everything is
working.

In the example above our initialize method seems like it might be a bit clunky
so we could perform the following refactor.

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

As you can see from the example above in the end it turns out that we end up
with more code in our test file than we have in the implementation of our
Airplane class. This is very often the case, and as an application grows the
tests grow with it and become almost if not more valuable as the application
itself. If the entire set of these written for a given program are all passing
then whatever code that has been written to implement that program is working,
however it works under the hood.

#### Forced attention to detail

There are also several other things that may have become apparent as we thought
through just writing these two initial basic tests. Before we even wrote the
code for our Airplane class much less the code for our `flying?` method we
thought through what the possible return values of that method could be and the
state our class would need to be in to return those values.

#### Refactoring confidence

One of the most valuable results of test driving our code is that we also were
left with a tool (single command the verified our code worked as expected) that
allowed us to change the internal structure of the code with confidence that we
aren't breaking any expected behavior. As your applications grow and grow this
becomes a more and more valuable tool. It saves untold amounts of time to let
the computer check that every edge case and side possibility of how we expect to
use our application code is working as expected.
