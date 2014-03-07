function missingNumber(numbers){
  n = numbers.length + 1;
  var total = n*(n+1)/2;
  for(var i = 0; i < numbers.length; i++){
    total -= numbers[i];
  }
  return total;
}
