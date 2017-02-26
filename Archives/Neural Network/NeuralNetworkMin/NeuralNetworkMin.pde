
void setup(){
  
  size(400,400);
  
  int[] n = {4};
  
  Network net = new Network(2,n,1);
  fill(0);
  float[] i = {1,1};
  long t=millis();
  
  for(int j=0;j<1000;j++) net.forward(i);
  
  text(round(millis()-t),10,10);
}


void draw(){
  
  
}