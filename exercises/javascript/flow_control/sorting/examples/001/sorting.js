function numberSort(numbers, option){
  return numbers.sort(function(a,b){ 
    if (option == 'desc'){
      return b - a;
    } else {
      return a - b;
    }
  });
}
