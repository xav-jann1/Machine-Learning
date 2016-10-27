
class ActivationFunction
{
  String functionName = "id";
  
  
  ActivationFunction(String s){ 
    functionName = s;   
  }
  
  
  float sum(float x){
    switch(functionName){  
      case "id":
        return x;
      
      case "sigmoid":
        return sigmoid(x);
      
      case "tanh":
       return tanh(x);
      
      default : 
        return x; 
    } 
  }
  
  float[] sum(float[] x){
    switch(functionName){ 
      case "id":
        return x;
      
      case "sigmoid":
        for(int i=0;i<x.length;i++) x[i] = sigmoid(x[i]);
        return x;
        
      case "tanh":
       for(int i=0;i<x.length;i++) x[i] = tanh(x[i]);
       return x;
      
      default : 
        return x;    
    }
  }
  
  float[][] sum(float[][] x){
    switch(functionName){  
      case "id":
        return x;
      
      case "sigmoid":
        for(int i=0;i<x.length;i++) for(int j=0; j<x[0].length; j++) x[i][j] = sigmoid(x[i][j]);
        return x;
      
      case "tanh":
        for(int i=0;i<x.length;i++) for(int j=0; j<x[0].length; j++) x[i][j] = tanh(x[i][j]);
        return x;
      
      default : 
        return x; 
    } 
  }
  
  
  float prime(float x){
    switch(functionName){
      
      case "id":
       return 0.00000001;
      
      case "sigmoid":
        return sigmoidPrime(x);
      
      case "tanh":
       return tanhPrime(x);
      
      default : 
        return x;   
    }   
  }
  
  float[] prime(float[] x){
    switch(functionName){ 
      case "id":
        for(int i=0;i<x.length;i++) x[i] = 0.00000001;
        return x;
      
      case "sigmoid":
        for(int i=0;i<x.length;i++) x[i] = sigmoidPrime(x[i]);
        return x;
        
      case "tanh":
       for(int i=0;i<x.length;i++) x[i] = tanhPrime(x[i]);
       return x;
      
      default : 
        return x;    
    }
  }
  
  float[][] prime(float[][] x){
    switch(functionName){  
      case "id":
        for(int i=0;i<x.length;i++) for(int j=0; j<x[0].length; j++) x[i][j] = 0.00000001;
        return x;
      
      case "sigmoid":
        for(int i=0;i<x.length;i++) for(int j=0; j<x[0].length; j++) x[i][j] = sigmoidPrime(x[i][j]);
        return x;
      
      case "tanh":
        for(int i=0;i<x.length;i++) for(int j=0; j<x[0].length; j++) x[i][j] = tanhPrime(x[i][j]);
        return x;
      
      default : 
        return x; 
    } 
  }
 
}


float sigmoid(float x){
  return 1/(1+exp(-x));
}

float tanh(float x){
  return (exp(x)-exp(-x)) / (exp(x)+exp(-x));  
}


float sigmoidPrime(float x){
  return exp(-x)/pow(1+exp(-x),2);
}

float tanhPrime(float x){
  return  1-pow(tanh(x),2); 
}