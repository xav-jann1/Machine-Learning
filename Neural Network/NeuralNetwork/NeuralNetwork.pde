Network network;

void setup(){  // TODO : Ajouter des messages d'erreurs
  
  size(900,900);
  frameRate(10);
  textAlign(CENTER,CENTER);
  
  background(255);
  translate(0,0); 
 
  //Système complet : ! nNeuron(i) = nWeights(i+1)
  /*int[][][] n = { { {1,2,1,2}, {2,1,2,1}, {3,0,1,2}, {1,1,2,1}, {2,1,3,1} },
                  { {1,1,1,1,1}, {1,1,1,1,1}, {1,1,1,1,1}, {1,1,1,1,1}, {1,1,1,1,1}, {1,1,1,1,1} },
                  { {1,1,1,1,1,1}, {1,1,1,1,1,1}, {1,1,1,1,1,1}, {1,1,1,1,1,1} },
                  { {1,1,1,1}, {1,1,1,1}, {1,1,1,1} }
                };
  int[][] o = {{1,1,1},{1,1,1},{1,1,1}};  // TODO ? : intégrer o dans n
  */
  

  int[] n = {3,2};
  //int[][][] n = {{{1,2},{3,4},{5,2}}};
  int[][] o = {{1,2,3}};
  
  network = new Network(1,3,1,"id");
  
    
  float mX = 0;
  float[][] x = new float[1000][1];
  for(int i=0;i<1000;i++){
    float r = random(0,5);
    x[i][0] = r;
    mX = max(mX,r);
  }
  
  float mY = 0;
  float[][] y = new float[1000][1];
  for(int i=0;i<1000;i++){
    y[i][0] = 2*x[i][0];
    mY = max(mY,2*x[i][0]);
  }
  
  /*for(int i=0;i<100;i++){
    x[i][0] ;
    y[i][0] ;
  }*/
  
  /*float[][] x = {{3,5},
                 {5,1},
                 {10,2}};
             
  float[][] y = {{75},
                 {82},
                 {93}};
  */
  showArray(x);
  showArray(y);
  
  
  Train train = new Train(network,x,y);
  
  println("cost : ", train.cost());
  println();
  //showArray(train.weights[0]);
  //showArray(train.weights[1]);
  
  
  for(int j=0; j<1000; j++){
    train.train();
    println("cost",j,":", train.cost());;
  }
  println();
  showArray(train.weights[0]);
  showArray(train.weights[1]);
  
  
  println("cost : ", train.cost());
  
  float[][] i = {{3}, {5}};
  
  println(network.forward(i[0])[0]);
  println(network.forward(i[1])[0]);
  
  
  network.display(900,900,60);
  
}


void draw(){
 
}


/*float[][] normExamples(float [][] x){  }*/

void showArray(float[][] grid){
  for(int i=0;i<grid.length;i++){
    for(int j=0;j<grid[0].length;j++){
      print(grid[i][j]+" ");
    }
    println(); 
  }
  println();
}