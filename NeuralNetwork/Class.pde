
class Neuron
{
  protected float[] weights;
  protected float output=0;
  
  Neuron(int w){
    weights = new float[w];
    for(int i=0;i<weights.length;i++) weights[i] = 1/*random(-1,1)*/;
  }
  
  float output(float[] inputs){
    float sum=0;
    for(int i=0;i<inputs.length;i++){
      sum+=inputs[i]*weights[i];
    }
    
    //softmax ou sigmoid
    
    output = sum;
    
    return sum;
  }
  
  float getValue(){
    return output;
  }
}


class Layer
{
  protected Neuron[] neurons;

  Layer(int n, int i){  //Nombre de neurones et nombre d'input par neurone
    neurons = new Neuron[n];
    for(int neuron=0; neuron<n; neuron++) neurons[neuron] = new Neuron(i);
  }
  
  
  int nNeurons(){
    return neurons.length;
  }
  
  float getValue(int n){
    return neurons[n].getValue();
  }
  
  float[] getValues(){
    float[] values = new float[0];  
    for(int neuron=0; neuron<neurons.length; neuron++) values = append(values, neurons[neuron].getValue());
    return values;
  }
  
  float[] newOutputs(float[] input){
    float[] outputs = new float[0];
    for(int neuron=0; neuron<neurons.length; neuron++){
      outputs = append(outputs,neurons[neuron].output(input));
    }
    
    return outputs;
  }

}


class Network
{
  protected float[] inputs;
  protected Layer[] layers;  //Hidden Layers + Outputs
  
  Network(int i, int l, int o){  //Hidden Layer
    inputs = new float[i];
    layers = new Layer[1+1];  //Hidden Layer + Outputs
    
    //Prepare layers:
    layers[0] = new Layer(l,i);
    layers[1] = new Layer(o,l);
  
  }
  
  Network(int i, int[] l, int o){  //Hidden Layers
    inputs = new float[i];
    layers = new Layer[l.length+1];
    
    //Prepare layers :
    for(int layer=0;layer<layers.length;layer++){
      if(layer==0) layers[layer] = new Layer(l[layer],i);  //1st Layer
       else if(layer==layers.length-1) layers[layer] = new Layer(o,l[layer-1]);  //Outputs
        else layers[layer] = new Layer(l[layer],l[layer-1]);  //Hidden Layers   
    }

  }
  
  
  /*void addNeuron(int n){
    neurons[n] = (Neuron[]) append(neurons[n], new Neuron(inputs.length));
  }*/

    
  float[] getValueFromLayer(int layer){
    
    if(layer==-1) layer = layers.length-1;
     else layer-=1;
    
    return layers[layer].getValues();
    
  }
  
  
  float[] outputs(float[] inputs){
    this.inputs = inputs;
    
    float[] layerValues = new float[0];
    
    for(int layer=0; layer<layers.length; layer++){
      if(layer==0) layerValues = layers[layer].newOutputs(inputs);
       else layerValues = layers[layer].newOutputs(layerValues);
    }
    
    return layerValues;
    
    //return output;
  }
  
  
  
  void display(float w, float h, int rC){  // float nécessaire pour éviter des 'faux écarts'
    
    w-=rC; h-=rC;
    translate(rC/2 + w/2, rC/2 + h/2);  //Enlève l'espace occupé par les rayons des cercles et centre au milieu
    
    //Ajout des couches :
    int[] neuronsInLayer = {inputs.length-1};
    for(int layer=0; layer<layers.length; layer++) neuronsInLayer = append(neuronsInLayer, layers[layer].nNeurons()-1);
    
    float e = h/max(neuronsInLayer);  //Ecart standard entre les cercles défini par la 'couche' ayant le plus de cercles
    float nLayers = neuronsInLayer.length;
    
    stroke(0); strokeWeight(1);
     
    for(int layer=0;layer<nLayers;layer++){ 
      float x = w/(nLayers-1)*(layer-(nLayers-1)/2);  //Position x de la couche
      float y0 = -e*neuronsInLayer[layer]/2;          //Position du 1er neurone en haut
      float y1=0; if(layer<nLayers-1) y1 = -e*neuronsInLayer[layer+1]/2;    //Position y de la couche suivante
      
      for(int neuron=0; neuron <= neuronsInLayer[layer]; neuron++){  //Neurones de la couche
      
        //Lignes qui se relient à la couche suivante :
        if(layer<nLayers-1){  //La dernière couche n'a pas de couche suivante !
          for(int nextNeuron=0; nextNeuron <= neuronsInLayer[layer+1]; nextNeuron++){
            //getWeightLine();
            line(x,y0+e*neuron,x+w/(nLayers-1),y1+e*nextNeuron);
          }
        }
                
        //Neurone :
        fill(255);
        ellipse(x,y0+e*neuron,rC,rC);
        
        fill(0);  //Valeur du neurone
        if(layer==0) text(int(inputs[neuron]),x,y0+e*neuron);
         else text(int(layers[layer-1].getValue(neuron)),x,y0+e*neuron);
      }
      
    }
    
       
  }

}