int[][] data = new int[0][16];

Grid grid;

void setup(){
  size(500,500);
  frameRate(60);
  
  grid = new Grid(4,4);
   //<>//
  
  textAlign(CENTER,CENTER);
}

int n=0;

void draw(){
  /*
  grid = newGrid();
  
  int[][] grid1 = {{8,0,0,8},
                   {0,4,2,0},
                   {0,2,0,0},
                   {2,0,2,2}};
  
  showGrid(grid);
  println(canMove(grid));
  println();
  
  
  
  
  if(keyPressed && key=='a' && firstPress){
    grid = addRandomNumber(grid);
    showGrid(grid);
  }*/
  
  //TODO : adapter pour que l'ordinateur joue tout seul
  
  background(255);
  
  //int input; //= int(random(4));//getInput();
  
  int input = int(log(random(20)));
  
  //int input=0; // = int(random(100));
  
  /*if(input<50) input=0;
   else if(input<90) input=3;
    else if(input<97) input=2;
     else  input=1;*/
/*
  
  if(n<5) input=3;
   else if(n<10) input=0;
    else if(n<15) input=3;
     else if(n<20) input=0;
      else if(n<21) input=2;
       else{
         n=0;
         if(random(100)<50) input=1;
       }
  n++;*/
  /*if(frameCount%20 < 10) input=0;
   else if(frameCount%50 < 20) input=3;
    else if(frameCount%50 < 40) input=2;
     else if(random(100)<5) input=1;*/
  
     
  grid.display(40);
  

  if(grid.moveGrid(input) && !grid.isFull()){
    translate(40*5,0);
    grid.display(40);
    fill(0); text(input,-40/2,40*4/2);

    grid.addRandomNumber();  //Add 2 or 4
  }
  
  //println(input);
  //showGrid(grid.grid);
  println();
 
}



int[] canMove(Grid grid){
  
  int[] m = new int[0];
  
  for(int i=0;i<4;i++){
    int[][] g = copyArray(grid.grid);
    m = append(m,int(grid.moveGrid(i)));
    
    grid.grid = g;
    //showGrid(g);
    //println();
  }
  
  return m;
}

int[][] copyArray(int [][] g){
  int[][] grid = new int[4][4];  
  for(int i=0;i<grid.length;i++) for(int j=0;j<grid.length;j++) grid[i][j] = g[i][j];
  return grid;
}

void showGrid(int[][] grid){
  for(int i=0;i<grid.length;i++){
    for(int j=0;j<grid.length;j++){
      print(grid[j][i]+" ");
    }
    println();
    
  }
  
}