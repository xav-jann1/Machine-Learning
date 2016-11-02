Network network;

void setup(){  // TODO : Ajouter des messages d'erreurs
  
  size(900,900);
  frameRate(10);
  textAlign(CENTER,CENTER);
  
  background(255);
  translate(0,0); 
   
   
  randomSeed(100);
  
  
  println("abcdefghijklmnopqrstuvwxyz");
  
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
  
  network = new Network(1,3,1,"id",true); //<>//
  
  network.forward(new float[]{1}); //<>//
  
  network.display(900,900,60);
  
    
  float mX = 0;
  float[][] x = new float[100][1];
  for(int i=0;i<100;i++){
    float r = random(0,5);
    x[i][0] = r;
    mX = max(mX,r);
  }
  
  float mY = 0;
  float[][] y = new float[100][1];
  for(int i=0;i<100;i++){
    y[i][0] = 2*x[i][0];
    mY = max(mY,2*x[i][0]);
  }
  
  for(int i=0;i<100;i++){
    x[i][0] /= 5;
    y[i][0] /= 5;
  }
  
  /*float[][] x = {{3,5},
                 {5,1},
                 {10,2}};
             
  float[][] y = {{75},
                 {82},
                 {93}};
  */
  //showArray(x);
  //showArray(y);
  
  
  /*GradientDescent train = new GradientDescent(network,x,y);
  
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
  
  
  
  println(network.forward(i[0])[0]);
  println(network.forward(i[1])[0]);
  */
  
  /*
  GeneticAlgorithm train = new GeneticAlgorithm(network,10,x,y);
  
  for(int j=0; j<10; j++){
    train.train();
    println("cost",j,":",min(train.costs()));
  }
  
  
  
  float[][] i = {{3}, {5}};
  
  Network net = train.bestNetwork();
  net.forward(i[1]);
  
  net.display(900,900,60);

  */
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