test('if passed the asc flag it should sort an array of numbers from low to high', function(){
  deepEqual(numberSort([1,4,3,2], 'asc'), [1,2,3,4], 'can sort from low to high');
});

test('if passed the desc flag it should sort an array of numbers from high to low', function(){
  deepEqual(numberSort([1,4,3,2], 'desc'), [4,3,2,1], 'can sort from high to low');
});

test('if no option is passed it should sort an array of numbers from low to high', function(){
  deepEqual(numberSort([1,4,3,2]), [1,2,3,4], 'sorts asc if no option passed');
});
