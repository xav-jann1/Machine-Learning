
float sigmoid(float x){
  return 1/(1+exp(-x));
}

float[] sigmoid(float[] x){
  float[] result = new float[x.length];
  for(int i=0;i<x.length;i++) result[i] = sigmoid(x[i]);
  return result;
}

float[][] sigmoid(float[][] x){
  float[][] result = new float[x.length][x[0].length];
  for(int i=0;i<x.length;i++) result[i] = sigmoid(x[i]);
  return result;
}


float sigmoidPrime(float x){
  return exp(-x)/pow(1+exp(-x),2);
}

float[] sigmoidPrime(float[] x){
  float[] result = new float[x.length];
  for(int i=0;i<x.length;i++) result[i] = sigmoidPrime(x[i]);
  return result;
}

float[][] sigmoidPrime(float[][] x){
  float[][] result = new float[x.length][x[0].length];
  for(int i=0;i<x.length;i++) result[i] = sigmoidPrime(x[i]);
  return result;
}