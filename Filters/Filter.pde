PImage iFilter(PImage image, float[][] kernel){
  
  int offset = kernel.length/2;
  
  PImage newImage = image.copy();
  newImage.loadPixels();
  
  int iWidth = image.width;
  int iHeight = image.height;
  
  for(int y=offset; y<iHeight-offset; y++){
    for(int x=offset; x<iWidth-offset; x++){
      newImage.pixels[x+y*iWidth] = colorPixel(x,y,image,kernel);
    }   
  }
  
  newImage = newImage.get(offset,offset,newImage.width-2*offset,newImage.height-2*offset);
  
  return newImage;
}


float sumKernel(float[][] kernel){
  float sum = 0;
  int kWidth = kernel.length;
  
  for(int i=0;i<kWidth;i++) for(int j=0;j<kWidth;j++) sum+=kernel[i][j]; 
  
  return sum; 
}

int colorPixel(int x, int y, PImage image, float[][] kernel){
  int iWidth = image.width;
  
  int offset = kernel.length/2;
  float sumKernel = sumKernel(kernel);
  
  float[] s = {0,0,0};  //R,G,B
  
  for(int i=-offset; i<=offset; i++){
    for(int j=-offset; j<=offset; j++){
      
      int px = (x+j) + (y+i)*iWidth;
      
      s[0] += red(image.pixels[px]) * kernel[i+offset][j+offset];
      s[1] += green(image.pixels[px]) * kernel[i+offset][j+offset];
      s[2] += blue(image.pixels[px]) * kernel[i+offset][j+offset];
    } 
  }
  
  s[0]/=sumKernel;
  s[1]/=sumKernel;
  s[2]/=sumKernel;

  return color(s[0],s[1],s[2]);
  
}


PImage iPixel(PImage image, int f){
  
  PImage newImage = createImage(image.width/f, (image.height-1)/f, RGB);    // (image.height-1) permet d'éviter un bug
  
  int iWidth = newImage.width;
  int iHeight = newImage.height;
  
  println(iWidth, iHeight);
  
  for(int y=0; y<iHeight; y++){
    for(int x=0; x<iWidth; x++){
      newImage.pixels[x+y*iWidth] = blockColorPixel(x,y,image,f);
    }   
  }
  
  return newImage;
  
}

int blockColorPixel(int x, int y, PImage image, int f){
  
  x*=f;
  y*=f;
  
  int iWidth = image.width;
  
  float[] s = {0,0,0};  //R,G,B
  
  for(int i=0; i<=f; i++){
    for(int j=0; j<=f; j++){
      
      int px = (x+j) + (y+i)*iWidth;
      
      s[0] += red(image.pixels[px]);
      s[1] += green(image.pixels[px]);
      s[2] += blue(image.pixels[px]);
    } 
  }
  
  s[0]/=f*f;
  s[1]/=f*f;
  s[2]/=f*f;

  return color(s[0],s[1],s[2]);
  
}