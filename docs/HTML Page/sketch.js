p5.disableFriendlyErrors = true;
var n;

function setup() {

  var canvas = createCanvas(250, 250);
  canvas.parent('p5-graph');
  
  background(250/*250*/);

  n = new Network(2, [3], 1);
  
  n.forward([1,1]);
  
  n.display(width,height,32);
  
}


function draw() {

  
}




