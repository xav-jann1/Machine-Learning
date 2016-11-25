
var express = require('express');

var app = express();

var server = app.listen(3010);

app.use(express.static('public'));

console.log("My socket server is running");

var socket = require('socket.io');

var io = socket(server);

io.sockets.on('connection', newConnection);

function newConnection(socket){
  console.log(socket.handshake.time + " :\n" + socket.handshake.headers['user-agent'] + "\n");

  socket.on('mouse', mouseMsg);

  function mouseMsg(data){
    socket.broadcast.emit('mouse', data);
    //console.log(data);
  }
}

