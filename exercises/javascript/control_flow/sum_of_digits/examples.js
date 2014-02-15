function sumDigits(number){
  convertedNumber = number.toString();
  sum = 0;
  for(var i = 0; i < convertedNumber.length; i++){
    sum += parseInt(convertedNumber[i]);
  }
  return sum;
}
