test("should swap all uppercase to lowercase", function(){
  ok(swapCase('HELLO') === 'hello', "can convert uppercase to lowercase");
});

test("should swap all lowercase to uppercase", function(){
  ok(swapCase('hello') === 'HELLO', "can convert lowercase to uppercase");
});

test("should swap cases", function(){
  ok(swapCase('hElLo') === 'HeLlO', "can convert all cases");
});
