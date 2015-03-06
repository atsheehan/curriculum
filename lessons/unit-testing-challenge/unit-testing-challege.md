# Unit Testing Yourself!

## Learning Goals

1. Get comfortable and familar with writing basic Rspec tests
2. Explore testing with multiple objects

Stretch

3. Write a test stub

## Instructions

- Write tests for and implement and Airplane class that you initialize with:
  type, wingloading, horsepower. Your tests should allow you to initialize an
  instance of an airplane and confirm the attributes for that instance have
  been stored.
- Write tests for a, start, takeoff, and land methods for your airplane class.
  Ensure that the plane is running for the takeoff method and test for this
  edge case.
- At this point your test file should be getting fairly large and probably does
  some of the same settup steps several times. Look up Rspec documentation for
  'let' syntax to share variables between tests.
- Add a 'fuel' internal attribute to your airplane that is set at initialization
  and the start, takeoff, and land methods modify appropriately. Add tests to
  each of those methods to ensure that the airplane has enough fuel to caryout
  those operations. (If fuel is too low for landing perhaps suggest
  alternatives for the airplane be creative!)
- Add tests for a 'passengers' attribute for the airplane and methods to
  load/unload those passengers with a maximum number dependant on the
  wingloading and/or horsepower.

## Extra

- Expect the 'passengers' that you will store in your passengers array will be
  another object (perhaps a User class). Stub these passenger objects in your
  Airplane class tests and make use of calling a stubbed 'weight' method on
  these passengers. (Like a max takeoff wieght for the airplane.)
