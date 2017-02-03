
class Neuron
{
  float[] weights;  //Poids du neurone pour chaque entrée
  float sum=0;      //Somme des entrées
  float output=0;   //Somme des entrées avec fonction d'activation
  
  Neuron(int i){
    weights = new float[i];    
    newRandomWeights();
  }
  
  Neuron(int[] w){  //Avec weights
    weights = new float[w.length];
    for(int j=0;j<weights.length;j++) weights[j] = w[j];
  }
  
  
  float output(float[] inputs, ActivationFunction f){
    float sum=0;
    for(int i=0;i<inputs.length;i++) sum+=inputs[i]*weights[i];
    
    this.sum = sum;
    
    //softmax ou sigmoid
    sum = f.sum(sum);  //Fonction d'activation
    output = sum;
    
    return sum;
  }
  
  float[] getWeights(){ return weights; }
  
  float getSum(){ return sum; }
  
  float getAnswer(){ return output; }
  
  void newWeights(float[] w){ weights = w; }
  
  void newRandomWeights(){  
    for(int i=0; i<weights.length; i++) weights[i] = random(-5,5);
  }
  
}


class Layer
{
  protected Neuron[] neurons;

  Layer(int n, int i){  //Nombre de neurones et nombre d'input par neurone
    neurons = new Neuron[n];
    for(int neuron=0; neuron<n; neuron++) neurons[neuron] = new Neuron(i);
  }
  
  Layer(int[][] n){  //Nombre de neurones, weights et nombre d'input par neurone
    neurons = new Neuron[n.length];
    for(int neuron=0; neuron<n.length; neuron++) neurons[neuron] = new Neuron(n[neuron]);
  }
  
  
  float[] forward(float[] input, ActivationFunction f){
    float[] outputs = new float[0];
    for(int neuron=0; neuron<neurons.length; neuron++){
      outputs = append(outputs,neurons[neuron].output(input, f));
    }
    return outputs;
  }
  
  
  int nNeurons(){ return neurons.length; }
  
  void newWeights(float[][] weights){
    for(int neuron=0; neuron<neurons.length; neuron++){
      neurons[neuron].newWeights(weights[neuron]);
    }
  }
  
  void newRandomWeights(){
    for(int neuron=0; neuron<neurons.length; neuron++){
      neurons[neuron].newRandomWeights();
    }
  }
  
  float[][] getAllWeights(){
    float[][] weights = new float[neurons.length][];  
    for(int neuron=0; neuron<neurons.length; neuron++) weights[neuron] = neurons[neuron].getWeights();
    return weights; 
  }
     
  float[] getAllSums(){
    float[] sums = new float[neurons.length];  
    for(int neuron=0; neuron<neurons.length; neuron++) sums[neuron] = neurons[neuron].getSum();
    return sums; 
  }
  
  float getAnswer(int n){ return neurons[n].getAnswer(); }
  
  float[] getAllAnswers(){
    float[] answers = new float[neurons.length];  
    for(int neuron=0; neuron<neurons.length; neuron++) answers[neuron] = neurons[neuron].getAnswer();
    return answers;
  }

}


class Network
{
  float[] inputs;
  int nInputs;
  Layer[] layers;  //Hidden Layers + Outputs
  
  ActivationFunction f;
  
  boolean bias = false;
  

  Network(int i, int l, int o, String s, boolean b){
    int intBias = 0;
    if(b) intBias = 1;
    
    inputs = new float[i];
    nInputs = i;
    layers = new Layer[1+1];  //Hidden Layer + Outputs
    
    //Prepare layers:
    layers[0] = new Layer(l,i+intBias);
    layers[1] = new Layer(o,l+intBias);
    
    f = new ActivationFunction(s);
    
    bias = b;
  }
  
  Network(int i, int l, int o, String s){  //Hidden Layer
    this(i,l,o,s,false);
  }
  
  
  Network(int i, int[] l, int o, String s, boolean b){  //Hidden Layers
    int intBias = 0;    
    if(b) intBias = 1;
    
    inputs = new float[i];
    nInputs = i;
    layers = new Layer[l.length+1];
    
    //Prepare layers :
    for(int layer=0;layer<layers.length;layer++){
      if(layer==0) layers[layer] = new Layer(l[layer],i+intBias);  //1st Layer
       else if(layer==layers.length-1) layers[layer] = new Layer(o,l[layer-1]+intBias);  //Outputs
        else layers[layer] = new Layer(l[layer],l[layer-1]+intBias);  //Hidden Layers   
    }
    
    f = new ActivationFunction(s);
    
    bias = b;
  }
  
  Network(int i, int[] l, int o, String s){  //Hidden Layers
    this(i,l,o,s,false);
  }
  
  
  Network(int i, int[][][] l, int[][] o, String s){  //Hidden Layers with weights - TODO : enlever l'entrée des outputs (l'intégrer dans l)
    inputs = new float[i];
    nInputs = i;
    layers = new Layer[l.length+1];
    
    //Prepare layers :
    for(int layer=0;layer<layers.length;layer++){
      if(layer==0) layers[layer] = new Layer(l[layer]);  //1st Layer
       else if(layer==layers.length-1) layers[layer] = new Layer(o);  //Outputs
        else layers[layer] = new Layer(l[layer]);  //Hidden Layers   
    }
    
    f = new ActivationFunction(s);
    
  }
  
  /*void addNeuron(int n){ neurons[n] = (Neuron[]) append(neurons[n], new Neuron(inputs.length)); }*/
    
  float[] forward(float[] inputs){
    this.inputs = inputs;

    float[] layerValues = new float[inputs.length];
    arrayCopy(inputs,layerValues);
    
    for(int layer=0; layer<layers.length; layer++){
      if(bias) layerValues = addBias(layerValues);
      //layerValues[layerValues.length-1] = 1;
      if(layer==layers.length-1) layerValues = layers[layer].forward(layerValues, f);  //--> problème à partir d'ici : boucle infinie ??? //<>//
       else layerValues = layers[layer].forward(layerValues, f);
    }
    
    return layerValues;
  }
  
  float[] addBias(float[] x){   
    x = append(x,1);
    return x;
  }
  
  
  float cost(float[] inputs, float[] outputs){
    float J =0 ;
    float[] y = forward(inputs);
    for(int i=0; i<outputs.length; i++) J += pow(outputs[i] - y[i], 2);
    return J;
  }
  
  
  float[][][] getAllWeights(){  //Layer, Neuron, weights
    float[][][] weights = new float[layers.length][][];  
    for(int layer=0; layer<layers.length; layer++) weights[layer] = layers[layer].getAllWeights();
    return weights;   
  }
  
  float[][] getAllSums(){
    float[][] sums = new float[layers.length][];  
    for(int layer=0; layer<layers.length; layer++) sums[layer] = layers[layer].getAllSums();
    return sums;
  }
  
  float[][] getAllAnswers(){
    float[][] answers = new float[layers.length][];  
    for(int layer=0; layer<layers.length; layer++) answers[layer] = layers[layer].getAllAnswers();
    return answers;
  }
  
  float[] getSumsFromLayer(int layer){ return layers[layer].getAllSums(); }
  
  float[] getAnswersFromLayer(int layer){ return layers[layer].getAllAnswers(); }
  
  void newWeights(float[][][] weights){  
    for(int layer=0; layer<layers.length; layer++){
      layers[layer].newWeights(weights[layer]);
    }
  }
  
  void newRandomWeights(){  
    for(int layer=0; layer<layers.length; layer++){
      layers[layer].newRandomWeights();
    }
  }
  
  Network copyParameters(){
    int[] nLayers = new int[network.layers.length-1];
    for(int l=0;l<network.layers.length-1;l++) nLayers[l] = network.layers[l].nNeurons();
    
    return new Network(nInputs,nLayers,nOutputs(),f.functionName,bias);
  }
  
  
  
  int nInputs(){ return inputs.length; }
  
  int nOutputs(){ return layers[network.layers.length-1].nNeurons(); }
  
  
  
  
  void display(float w, float h, int rC){  // float nécessaire pour éviter des 'faux écarts'
    
    w-=rC; h-=rC;
    translate(rC/2 + w/2, rC/2 + h/2);  //Enlève l'espace occupé par les rayons des cercles et centre au milieu
    
    //Ajout des couches :
    int[] neuronsInLayer = {nInputs-1}; //inputs.length-1};
    //if(bias) neuronsInLayer[0]++;
    
    for(int layer=0; layer<layers.length; layer++) neuronsInLayer = append(neuronsInLayer, layers[layer].nNeurons()-1);
    
    if(bias) for(int layer=0; layer<neuronsInLayer.length-1; layer++) neuronsInLayer[layer]++ ;  //Ajoute un neurone pour chaque couche sauf l'output 
    
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
            if(bias){
              if(nextNeuron<neuronsInLayer[layer+1] || layer==nLayers-2 )  line(x,y0+e*neuron,x+w/(nLayers-1),y1+e*nextNeuron);
            }else line(x,y0+e*neuron,x+w/(nLayers-1),y1+e*nextNeuron);
            
          }
        }
                
        //Neurone :
        fill(255);
        ellipse(x,y0+e*neuron,rC,rC);
        
        fill(0);  //Valeur du neurone
        
        if(bias && layer<nLayers-1 && neuron == neuronsInLayer[layer]){
          text(1,x,y0+e*neuron);
        }else{
          if(layer==0){
            if(neuron > inputs.length-1) text("e",x,y0+e*neuron);
             else text(int(inputs[neuron]),x,y0+e*neuron);
          }else text(layers[layer-1].getAnswer(neuron),x,y0+e*neuron);
        }
      }
      
    }
   
  }

}