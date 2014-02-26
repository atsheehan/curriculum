test("returns true for a leap year", function(){
  ok(leapYear(2000) == true, "Is a leap year!");
});

test("returns false for a non leap year", function(){
  ok(leapYear(1999) == false, "Is not a leap year!");
});

test("returns false for a non leap year", function(){
  ok(leapYear(1900) == false, "Is not a leap year!");
});

test("returns true for a leap year", function(){
  ok(leapYear(1996) == true, "Is a leap year!");
});
