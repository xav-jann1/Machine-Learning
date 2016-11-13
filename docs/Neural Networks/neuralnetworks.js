p5.disableFriendlyErrors = true;
var n;

function setup() {

  createCanvas(windowWidth, windowHeight);
  background(240);

  n = new Network(2, [3,3], 1);
  
  n.forward([1,1]);
  
  n.display(width,height,45);
  
}


function draw() {

  
}




