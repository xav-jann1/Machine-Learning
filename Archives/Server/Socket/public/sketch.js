var socket;

function setup() {
  createCanvas(800,800);
  background(200);
  noStroke();

  socket = io.connect('http://77.130.132.25:3010');

  socket.on('mouse', newDrawing);

}

function newDrawing(data){
  fill(255,0,100);
  ellipse(data.x,data.y,50,50);

}

function mouseDragged(){
  console.log('Sending: ' + mouseX + ',' + mouseY);

  var data = {
    x: mouseX,
    y: mouseY
  }

  socket.emit('mouse', data);

  fill(255);
  ellipse(touchX,touchY,50,50);

}


function draw() {

}