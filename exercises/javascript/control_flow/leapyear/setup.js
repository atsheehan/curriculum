var oldLog = console.log;
var lastLog;

window.onload = function(){
  console.log = function () {
    lastLog = arguments[0];
    oldLog.apply(console, arguments);
  };
};
