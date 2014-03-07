// Example 1

function oddNumbers(){
  oddNumbers = [];
  for (var i=1; i <= 100; i++){
    if (i % 2 == 1){
      oddNumbers.push(i);
    }
  }
  console.log(oddNumbers);
}
