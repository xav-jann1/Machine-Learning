

void UI(){
  int rectW = 50;
  for(int x=0;x<3;x++){
    for(int y=0;y<3;y++){
      
      if(mouseX>x*rectW && mouseX<(x+1)*rectW && mouseY>y*rectW && mouseY<(y+1)*rectW){
        fill(100);
        if(mouseWheel==-1){
          newImage=true;
          kernel[y][x]+=0.2;
        }
        if(mouseWheel==1){
          newImage=true;
          kernel[y][x]-=0.2;
        }
      }else fill(200);

      
      rect(x*rectW,y*rectW,rectW,rectW);
      fill(0);
      text(String.format("%.1f", kernel[y][x]),x*rectW+rectW/2,y*rectW+rectW/2);
      
    }
  }
  
  
  
}