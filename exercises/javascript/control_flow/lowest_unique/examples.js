function lowestUnique(numbers){
  numbers.sort(function(a,b){return a - b});
  for(var i = 0; i < numbers.length; i++){
    if (numbers[i] != numbers[i-1] && numbers[i] != numbers[i+1]){
      return numbers[i];
    }
  }
  return 0;
}
