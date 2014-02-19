test("should swap all uppercase to lowercase", function(){
  deepEqual(swapCase('HELLO'), 'hello', "can convert uppercase to lowercase");
});

test("should swap all lowercase to uppercase", function(){
  deepEqual(swapCase('hello'), 'HELLO', "can convert lowercase to uppercase");
});

test("should swap cases", function(){
  deepEqual(swapCase('hElLo'), 'HeLlO', "can convert all cases");
});
