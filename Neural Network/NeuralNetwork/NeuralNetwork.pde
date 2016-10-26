Network network;

void setup(){
  
  size(900,900);
  
  frameRate(10);
  
  textAlign(CENTER,CENTER);
  
  //int[] n = {5,4,6,5,2,3};

  
  //Système complet : ! nNeuron(i) = nWeights(i+1)
  /*int[][][] n = { { {1,2,1,2}, {2,1,2,1}, {3,0,1,2}, {1,1,2,1}, {2,1,3,1} },
                  { {1,1,1,1,1}, {1,1,1,1,1}, {1,1,1,1,1}, {1,1,1,1,1}, {1,1,1,1,1}, {1,1,1,1,1} },
                  { {1,1,1,1,1,1}, {1,1,1,1,1,1}, {1,1,1,1,1,1}, {1,1,1,1,1,1} },
                  { {1,1,1,1}, {1,1,1,1}, {1,1,1,1} }
                };
  int[][] o = {{1,1,1},{1,1,1},{1,1,1}};  // TODO ? : intégrer o dans n
  */
  
  
  //int n=3;
  //network = new Network(5,n,2);
  
  int[][][] n = {{{1,2},{3,4},{5,2}}};
  int[][] o = {{1,2,3}};
  
  network = new Network(2,3,1);
  
  background(255);
  translate(0,0); 
  
  // TODO : Ajouter des messages d'erreurs
  
  
  
  
  float[][] x = {{3/10.,5/5.},
                 {5/10.,1/5.},
                 {10/10.,2/5.}};
  
  showArray(x);
  
  float[][] y = {{0.75},
                 {0.82},
                 {0.93}};
  
  //println(x[1][1]);
  //network.costFunctionPrime(x,y);
  
  
  
  //printArray(mDot(x,y));
  

  
  Train train = new Train(network,x,y);
  
  println("cost : ", train.cost());
  println();
  showArray(train.weights[0]);
  showArray(train.weights[1]);
  
  for(int j=0; j<5000; j++){
    train.train();
    //println("cost",j,":", train.cost());;
  }
  println();
  showArray(train.weights[0]);
  showArray(train.weights[1]);
  
  ///train.train();
  
  println("cost : ", train.cost());
  
  float[] i = {3/10.,5/5.};
  
  println(network.forward(i));
  network.display(900,900,60);
  
}

void draw(){
  
 
  
}

void showArray(float[][] grid){
  for(int i=0;i<grid.length;i++){
    for(int j=0;j<grid[0].length;j++){
      print(grid[i][j]+" ");
    }
    println();
    
  }
  println();
  
}