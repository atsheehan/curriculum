function fizzbuzz(){
  numbers = [];
  for (var i=1;i<=100;i++){
    if (i % 15 == 0){
      numbers.push('FizzBuzz');
    } else if(i % 5 == 0){
      numbers.push('Buzz');
    } else if(i % 3 ==0){
      numbers.push('Fizz');
    } else {
      numbers.push(i);
    }
  }
  console.log(numbers);
}
