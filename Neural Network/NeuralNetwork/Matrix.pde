
float[] mAdd(float[] x, float[] y){
  float[] s = new float[x.length]; 
  for(int i=0; i<x.length; i++) s[i] = x[i] + y[i]; 
  return s;
}

float[][] mAdd(float[][] x, float[][] y){
  float[][] s = new float[x.length][x[0].length]; 
  for(int i=0; i<x.length; i++) s[i] = mAdd(x[i], y[i]); 
  return s;
}


float[] mSub(float[] x, float[] y){
  float[] s = new float[x.length]; 
  for(int i=0; i<x.length; i++) s[i] = x[i] - y[i]; 
  return s;
}

float[][] mSub(float[][] x, float[][] y){
  float[][] s = new float[x.length][x[0].length]; 
  for(int i=0; i<x.length; i++) s[i] = mSub(x[i], y[i]); 
  return s;
}


float[] mInv(float[] x){
  float[] s = new float[x.length]; 
  for(int i=0; i<x.length; i++) s[i] = -x[i]; 
  return s;
}

float[][] mInv(float[][] x){
  float[][] s = new float[x.length][x[0].length]; 
  for(int i=0; i<x.length; i++) s[i] = mInv(x[i]); 
  return s;
}


float[][] mProduct(float[][] x, float k){
  float[][] s = new float[x.length][x[0].length]; 
  for(int i=0; i<x.length; i++)
    for(int j=0; j<x[0].length; j++) s[i][j] = x[i][j] * k; 
  return s;
}

float[] mProduct(float[] x, float[] y){
  float[] s = new float[x.length]; 
  for(int i=0; i<x.length; i++) s[i] = x[i] * y[i]; 
  return s;
}

float[][] mProduct(float[][] x, float[][] y){
  float[][] s = new float[x.length][x[0].length]; 
  for(int i=0; i<x.length; i++){
    for(int j=0;j<x[0].length;j++) s[i][j] = x[i][j] * y[i][j];
  }
   
  return s;
}


float[][] mDot(float[][] x, float[][] y){
  float[][] s = new float[x.length][y[0].length]; 
  for(int i=0; i<x.length; i++){
    for(int j=0; j<y[0].length; j++){
      s[i][j]=0;
      for(int k=0; k<x[0].length; k++) s[i][j] += x[i][k] * y[k][j];
    }
  }
  return s;
}



float[][] mT(float[][] x){
  float[][] s = new float[x[0].length][x.length];
  for(int i=0; i<x.length; i++){
    for(int j=0; j<x[0].length; j++) s[j][i] = x[i][j]; 
  }
  return s;
}

float[] listArray(float[][] x){
  
  if(x[0].length>1) println("Error : listArray, length>1");
  
  float[] s = new float[x.length];
  for(int i=0; i<x.length; i++) s[i] = x[i][0];
  return s;
}