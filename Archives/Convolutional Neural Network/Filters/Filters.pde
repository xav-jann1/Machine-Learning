PImage image, image2;
float[][] kernel = {{ -1, 0, 1},
                    { -2, 0, 2},
                    { -1, 0, 1}};
void setup(){
  
  size(1000,800);
  
  
  
  image = loadImage("vlcsnap-error312.png");
  
  //image = image.get(150,80,501,521);
  long t=millis();
  image = iPixel(image,30);
  
  
  
  image2 = image.copy();
  
  background(255);
  
  image = iFilter(image,kernel);
  
  println(image.height%10);
  
  println(millis()-t);
  
  
  
  image(image,1,1);
  
  image(image2,image.width+2,1);
  
  
  
  textAlign(CENTER,CENTER);
}

boolean newImage = false;

void draw(){
  //background(255);
  translate(width/2-75,height/2);
  mouseX-=width/2-75;
  mouseY-=height/2;

  UI();
  mouseX+=width/2-75;
  mouseY+=height/2;
  
  resetMatrix();
  
  if(mousePressed){
    kernel = newKernel(kernel);
    newImage=true;
  }
  
  if(newImage){
    newImage=false;
    image = iFilter(image2,kernel);
    image(image,1,1);
  }
  
  mouseWheel = 0;
  
  //println(frameRate);
 
  
}


float[][] newKernel(float[][] kernel){
  
  int x = int(random(kernel.length));
  int y = int(random(kernel.length));
  
  float val = random(-0.5,0.5);
  
  kernel[x][y] += val;
  
  kernel[x][y] = constrain(kernel[x][y],-5,5);
  
  return kernel;
  
}

int mouseWheel=0;
void mouseWheel(MouseEvent event){
  mouseWheel = event.getCount();
}