function fizzbuzz(){
  var numbers = [];
  for (var i = 1; i <= 100; i++) {
    str = ""
    if (i % 3 == 0) { str += "Fizz" }
    if (i % 5 == 0) { str += "Buzz" }
    numbers.push(str == "" ? i : str);
  }
  console.log(numbers);

