var b=[];

function setup() {
  createCanvas(800,200);
  textAlign(CENTER,CENTER);
  
  var n=2;
  for(var i=0;i<4;i++) b.push(new Layer(n));
  
}

function draw() {
  background(255);
  var x=50; var e=20;
  var y=100; var d=50; 
  for(var i=b.length-1;i>=0;i--){
    b[i].display(x+(d+e)*i,y,d);
    
    if(b[i].n<1){
      if(b.length>3) b.splice(i,1); //Deleete Layer
       else b[i].n=1;
    }
    
    
    if(mouseX>x+(d+e)*i-d/2-e && mouseX<x+(d+e)*i-d/2 && mouseY>y-d && mouseY<y+d/2){ //Add Layer
      ellipse(x+(d+e)*i-d/2-e/2,y-d/2,d/2,d/2);
      line(x+(d+e)*i-d/2-e/2, y-d/2-d/10,x+(d+e)*i-d/2-e/2, y-d/2+d/10);  // |
      line(x+(d+e)*i-d/2-e/2-d/10, y-d/2, x+(d+e)*i-d/2-e/2+d/10, y-d/2);  // -
      if(mouseP && dist(mouseX,mouseY,x+(d+e)*i-d/2-e/2,y-d/2)<d/2){
        splice(b,new Layer(2),i);
      }
    }

  }
  
  mouseP=false;
}


var mouseP=false;
function mousePressed(){
  mouseP = true;
  
}

function Layer(n){
   
  this.n = n;  //Valeur
  
  this.bShowButtons = false;
  
  this.display = function(x,y,d){
    if(dist(mouseX,mouseY,x,y)<d/2){
      this.bShowButtons = true;
    }
    
    if(this.bShowButtons){
      if(mouseX<x-d/2-2 || mouseX>x+d/2+2 || mouseY<y-d*1.1-d/4 || mouseY>y+d*1.1+d/4) this.bShowButtons = false;
      else this.showButtons(x,y,d);
    }
    ellipse(x,y,d,d);
    text(this.n,x,y);
    
  }
  
  this.showButtons = function(x,y,d){
    if(mouseP){
      if(dist(mouseX,mouseY,x,y-d/1.1)<d/2) this.n++;
      if(dist(mouseX,mouseY,x,y+d/1.1)<d/2) this.n--;
    } 
    
    ellipse(x,y-d/1.1,d/2,d/2);
    line(x,y-d/1.1-d/10,x,y-d/1.1+d/10);  // |
    line(x-d/10,y-d/1.1,x+d/10,y-d/1.1);  // -
    
    ellipse(x,y+d/1.1,d/2,d/2);
    line(x-d/10,y+d/1.1,x+d/10,y+d/1.1)   // -
  }
  
  
  
}