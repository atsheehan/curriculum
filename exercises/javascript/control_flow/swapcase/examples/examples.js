// Example 1

function swapCase(string){
  var swappedString = '';
  for(var i=0; i<string.length;i++){
    if (string[i] == string[i].toLowerCase()){
      swappedString += string[i].toUpperCase();
    } else {
      swappedString += string[i].toLowerCase();
    }
  }
  return swappedString;
}
