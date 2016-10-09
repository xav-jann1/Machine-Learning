class Grid
{
  int[][] grid;
  int score;
  
  boolean hadMove;
  int[][] alreadyMove;
  
  Grid(int w, int h){
    startGame(w,h);
  }
  
  void startGame(int w, int h){  //Create new grid
    grid = new int[w][h];
    addRandomNumber();
    score=0;
  }
  
  void endGame(){
    
    println("end !!!!");
    
    
  }
  
  
  void addRandomNumber(){    
    boolean addNumber=false;
    while(!addNumber){
      int x = int(random(grid.length));
      int y = int(random(grid[0].length));
      
      if(grid[x][y]==0){
        int n=2; if(int(random(10))==5) n=4; 
        grid[x][y]=n; 
        break;
      }
    }
  }
  
  
  boolean isFull(){
    for(int i=0;i<grid.length;i++)
      for(int j=0;j<grid[i].length;j++)
        if(grid[i][j]==0) return false;  
    return true;
  }
  
  
  boolean moveGrid(int move){  // TODO: Reconnaître 'UP','RIGHT','DOWN','LEFT'
  
    hadMove=false;
    alreadyMove = new int[0][2];
    
    int x0=0, y0=0;  //Position de départ de l'analyse des cases 
    int cx=0, cy=0;  //Mouvement des cases
    int t=0;         //Translation positive ou négative après la vérifiaction d'une rangée ou colonne
    
    switch(move){
      case 0:
        y0=1; cy=-1;
        t=1;
        break;
      case 1:
        x0=2; cx=1;
        t=-1;
        break;
      case 2:
        y0=2; cy=1;
        t=-1;
        break;
      case 3:
        x0=1; cx=-1;
        t=1;
        break;
        
      default:
        return false;
    }
  
    int x=x0, y=y0, m=0;
    if(move==0 || move==2) m=0;  //Mouvement horizontal
     else m=1;  //Mouvement verticale
     
  
    for(int i=0;i<3;i++){  // TODO : Adapter les limites pour toutes les dimensions possibles de la grid
      for(int j=0;j<4;j++){
          int newCx=x, newCy=y;
          int caseValue=grid[x][y];
        if(caseValue!=0){
          boolean foundNewCase=false, mixCase=false;
          while(!foundNewCase){
            newCx+=cx;
            newCy+=cy;
            
            if(newCx<0 || newCx>3 || newCy<0 || newCy>3){  //Position en dehors de la zone de jeu      
              foundNewCase=true;
              newCx-=cx;  //Ancienne position avant erreur
              newCy-=cy;
              break;
            }
            
            if(grid[newCx][newCy]!=0){
              foundNewCase=true;
              if(grid[newCx][newCy]==caseValue && !hadAlreadyMove(newCx,newCy)){
                mixCase=true;
              }else{
                newCx-=cx;  //Reprend l'ancienne position
                newCy-=cy;
              }
            }
            
          }
          
          if(newCx!=x || newCy!=y) hadMove=true;
   
          grid[x][y]=0;
          if(mixCase){
            grid[newCx][newCy]=caseValue*2;
            alreadyMove = (int[][]) append(alreadyMove, new int[] {newCx,newCy});
          }
           else grid[newCx][newCy]=caseValue;
           
        }
    
        if(m==0) x+=1;  //Prochaine position
         else y+=1;    
      }
      
      if(m==0){y+=t; x=x0;}  //Prochaine colonne ou rangée
       else{x+=t; y=y0;}   
    }
    
    return hadMove;
  }
  
  boolean hadAlreadyMove(int x, int y){ 
    for(int i=0;i<alreadyMove.length;i++){
      if(alreadyMove[i][0]==x && alreadyMove[i][1]==y) return true;
    }
    return false; 
  }
  
  
  void displayGrid(int l){
    fill(255); stroke(0); textAlign(CENTER,CENTER); textSize(14);
    for(int i=0;i<grid.length;i++){
      for(int j=0;j<grid[0].length;j++){
        fill(255); rect(i*l,j*l,l,l);
        if(grid[i][j]!=0) fill(0); text(grid[i][j],i*l+l/2,j*l+l/2);
      }  
    }  
  } 
  
}