Network network;

void setup(){
  
  size(900,900);
  
  frameRate(10);
  
  textAlign(CENTER,CENTER);
  
  int[] n = {5,4,6,8,2,3};
  //int n=3;
  network = new Network(3,n,4);  
  
  background(255);
  translate(0,0); 
  
  float[] i = {0,0,0};
  
  long t = millis();
  
  println(network.outputs(i));
  println(network.outputs(i));
  println(millis()-t);
  
  network.display(900,900,70);
  
}

void draw(){
  
 
  
}