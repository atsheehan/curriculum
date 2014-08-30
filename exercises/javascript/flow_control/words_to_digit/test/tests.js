test('it converts a word into a digit', function(){
  deepEqual(wordToDigit('zero'), 0, 'converts one word');
});

test('it converts multiple words seperated by a semi-colon', function(){
  deepEqual(wordToDigit('zero;one'), 01, 'converts semi-colon seperated words');
});

test('it converts multiple words seperated by a semi-colon', function(){
  deepEqual(wordToDigit('eight;one;five'), 815, 'converts semi-colon seperated words');
});
