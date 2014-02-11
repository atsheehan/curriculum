test('returns the lowest unique number if there is one', function(){
  ok(lowestUnique([3, 3, 9, 1, 6, 5, 8, 1, 5, 3]) == 6, 'found the lowest unique number');
});

test('returns 0 if there is no lowest unique number', function(){
  ok(lowestUnique([1, 1, 5, 5, 3, 3, 9, 9,]) == 0, 'no unique number found');
});
