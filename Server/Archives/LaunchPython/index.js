
console.log('Server is starting..');

var express = require('express');

var app = express();

//var server = app.listen(3000, listening);

function listening(){
  console.log("wait for questions..");

}

app.use(express.static('public'));

var spawn = require("child_process").spawn;
var process = spawn('python',["public/test.py"]);

process.stdout.on('data', function (data){
  console.log(data.toString());
});
