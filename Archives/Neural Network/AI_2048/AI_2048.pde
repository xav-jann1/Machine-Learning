
Grid g;

void setup(){
  size(500,500);
  frameRate(60);
  g = new Grid(4,4);
  //grid.startGame(4,4);
  showGrid(g.grid);
  
}

void draw(){
  
  background(255);
  
  /*if(keyPressed && key=='a' && firstPress){
    grid = addRandomNumber(grid);
    showGrid(grid);
  }*/
  
  int input = getInput();
  
  if(input!=-1){
    
    if(g.moveGrid(input) && !g.isFull()) g.addRandomNumber();
    
     //else g.endGame();
  
    //showGrid(g.grid);
  }
  
  
  g.displayGrid(30);
   
}

boolean firstPress = true;
int getInput(){
  
  if(keyPressed && firstPress){
    firstPress=false;
    if(key==CODED){
      switch(keyCode){   
        case UP:
          return 0;
        case RIGHT:
          return 1;
        case DOWN:
          return 2;
        case LEFT:
          return 3;
      }
    } 
  }else if(!keyPressed) firstPress=true;

  return -1; 
}

void showGrid(int[][] grid){
  for(int i=0;i<grid.length;i++){
    for(int j=0;j<grid.length;j++){
      print(grid[j][i]+" ");
    }
    println();
    
  }
  println();
  
}