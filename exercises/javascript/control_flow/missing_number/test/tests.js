test('given an array of consecutive numbers with 1 missing, it finds the missing one', function(){
  deepEqual(missingNumber([1,2,4]), 3, 'found it');
});
test('the array can be unsorted', function(){
  deepEqual(missingNumber([4,2,1]), 3, 'found it!');
});
