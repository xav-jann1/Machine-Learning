Network network;

void setup(){
  
  size(900,900);
  
  frameRate(10);
  
  textAlign(CENTER,CENTER);
  
  int[] n = {5,4,6,5,2,3};

  
  //Système complet : ! nNeuron(i) = nWeights(i+1)
  /*int[][][] n = { { {1,2,1,2}, {2,1,2,1}, {3,0,1,2}, {1,1,2,1}, {2,1,3,1} },
                  { {1,1,1,1,1}, {1,1,1,1,1}, {1,1,1,1,1}, {1,1,1,1,1}, {1,1,1,1,1}, {1,1,1,1,1} },
                  { {1,1,1,1,1,1}, {1,1,1,1,1,1}, {1,1,1,1,1,1}, {1,1,1,1,1,1} },
                  { {1,1,1,1}, {1,1,1,1}, {1,1,1,1} }
                };
  int[][] o = {{1,1,1},{1,1,1},{1,1,1}};  // TODO ? : intégrer o dans n
  */
  
  
  //int n=3;
  network = new Network(5,n,2);  
  
  background(255);
  translate(0,0); 
  
  // TODO : Ajouter des messages d'erreurs
  float[] i = {1,0,3,4};
  
  long t = millis();
  
  println(network.outputs(i));
  println(millis()-t);
  println(network.outputs(i));
  
  
  network.display(900,900,40);
  
}

void draw(){
  
 
  
}