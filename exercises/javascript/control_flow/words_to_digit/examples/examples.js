function wordToDigit(word){
  convertedWord = '';
  seperatedWords = word.split(';');
  seperatedWords.forEach(function(word){
    switch (word) {
      case 'zero':
        convertedWord += '0';
        break;
      case 'one':
        convertedWord += '1';
        break;
      case 'two':
        convertedWord += '2';
        break;
      case 'three':
        convertedWord += '3';
        break;
      case 'four':
        convertedWord += '4';
        break;
      case 'five':
        convertedWord += '5';
        break;
      case 'six':
        convertedWord += '6';
        break;
      case 'seven':
        convertedWord += '7';
        break;
      case 'eight':
        convertedWord += '8';
        break;
      case 'nine':
        convertedWord += '9';
        break;
    }
  });
  return parseInt(convertedWord);
}
