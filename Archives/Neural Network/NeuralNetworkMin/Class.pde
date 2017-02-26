

class Neuron
{
  float[] weights;  //Poids du neurone pour chaque entrée
  float sum=0;      //Somme des entrées
  float output=0;   //Somme des entrées avec fonction d'activation
  
  Neuron(int i){
    weights = new float[i];    
    for (int w = 0; w < i; w++) weights[w] = 1;
  }

  float output(float[] inputs){
    sum=0;
    for(int i=0;i<inputs.length;i++) sum+=inputs[i]*weights[i];

    output = sum;
    
    return sum;
  }

}


class Layer
{
  Neuron[] neurons;

  Layer(int n, int i){  //Nombre de neurones et nombre d'input par neurone
    neurons = new Neuron[n];
    for(int neuron=0; neuron<n; neuron++) neurons[neuron] = new Neuron(i);
  }
    
  
  float[] forward(float[] input){
    float[] outputs = new float[0];
    for(int neuron=0; neuron<neurons.length; neuron++){
      outputs = append(outputs,neurons[neuron].output(input));
    }
    return outputs;
  }
  
}


class Network
{
  float[] inputs;
  Layer[] layers;  //Hidden Layers + Outputs
  
  
  Network(int i, int[] l, int o){  //Hidden Layers    
    inputs = new float[i];
    layers = new Layer[l.length+1];
    
    //Prepare layers :
    for(int layer=0;layer<l.length;layer++){
      if(layer==0) layers[layer] = new Layer(l[layer],i);  //1st Layer
        else layers[layer] = new Layer(l[layer],l[layer-1]);  //Hidden Layers   
    }
    layers[l.length] = new Layer(o,l[l.length-1]);  //Outputs

  }

  float[] forward(float[] inputs){
    this.inputs = inputs;

    float[] layerValues = new float[inputs.length];
    arrayCopy(inputs,layerValues);
    
    for(int layer=0; layer<layers.length; layer++){
      layerValues = layers[layer].forward(layerValues);
    }
    
    return layerValues;
  }
  
   
}