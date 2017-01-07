String labelFile = "train-labels.idx1-ubyte", imageFile = "train-images.idx3-ubyte";
byte[] label, image;

void setup(){  
  size(280,280);
  frameRate(10);
  textSize(20);
  
  label = loadBytes(labelFile);
  image = loadBytes(imageFile); 
}

int n=0, r=10;

void draw(){
  background(255);
  
  int[] i = pickImage(image,n);
  int l = pickLabel(label,n);

  for(int x=0;x<28;x++){
    for(int y=0;y<28;y++){
      fill(i[28*y+x]);
      rect(x*r,y*r,r,r);   
    } 
  }
  
  fill(250);
  text(l,28*r-16,20);
  text(n,28*r-16+8-textWidth(str(n)),height-10);
  
  if(mousePressed){
    if(mouseButton==LEFT) n++;
    if(mouseButton==RIGHT) n--;
  }
}


int[] pickImage(byte[] images, int n){
  
  int[] image = new int[784];
  
  for(int i=0;i<784;i++) image[i] = int(images[16+784*n+i]);
  
  return image;
}

int pickLabel(byte[] labels, int n){
  return label[8+n];
}