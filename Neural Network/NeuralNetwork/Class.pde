
class Neuron
{
  protected float[] weights;
  protected float sum=0;
  protected float output=0;
  
  Neuron(int i){
    weights = new float[i];
    for(int j=0;j<weights.length;j++) weights[j] = random(-1,1);
  }
  
  Neuron(int[] w){  //Avec weights
    weights = new float[w.length];
    for(int j=0;j<weights.length;j++) weights[j] = w[j];
  }
  
  
  float output(float[] inputs){
    float sum=0;
    for(int i=0;i<inputs.length;i++) sum+=inputs[i]*weights[i];
    
    this.sum = sum;
    
    //softmax ou sigmoid
    sum = sigmoid(sum);
    output = sum;
    
    return sum;
  }
  
  float[] getWeights(){
    return weights;
  }
  
  float getSum(){
    return sum;
  }
  
  float getAnswer(){
    return output;
  }
  
  void newWeights(float[] w){
     weights = w;  
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
  
  
  float[] forward(float[] input){
    float[] outputs = new float[0];
    for(int neuron=0; neuron<neurons.length; neuron++){
      outputs = append(outputs,neurons[neuron].output(input));
    }
    
    return outputs;
  }
  
  int nNeurons(){
    return neurons.length;
  }
  
  float[][] getAllWeights(){
    float[][] weights = new float[neurons.length][];  
    for(int neuron=0; neuron<neurons.length; neuron++) weights[neuron] = neurons[neuron].getWeights();
    return weights; 
  }
   
  float getAnswer(int n){
    return neurons[n].getAnswer();
  }
  
  float[] getAllSums(){
    float[] sums = new float[neurons.length];  
    for(int neuron=0; neuron<neurons.length; neuron++) sums[neuron] = neurons[neuron].getSum();
    return sums; 
  }
  
  float[] getAllAnswers(){
    float[] answers = new float[neurons.length];  
    for(int neuron=0; neuron<neurons.length; neuron++) answers[neuron] = neurons[neuron].getAnswer();
    return answers;
  }
  
  
  
  void newWeights(float[][] weights){
    
    for(int neuron=0; neuron<neurons.length; neuron++){
      neurons[neuron].newWeights(weights[neuron]);
    }
    
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
  
  Network(int i, int[][][] l, int[][] o){  //Hidden Layers with weights - TODO : enlever l'entrée des outputs (l'intégrer dans l)
    inputs = new float[i];
    layers = new Layer[l.length+1];
    
    //Prepare layers :
    for(int layer=0;layer<layers.length;layer++){
      if(layer==0) layers[layer] = new Layer(l[layer]);  //1st Layer
       else if(layer==layers.length-1) layers[layer] = new Layer(o);  //Outputs
        else layers[layer] = new Layer(l[layer]);  //Hidden Layers   
    }

  }
  
   
  /*void addNeuron(int n){
    neurons[n] = (Neuron[]) append(neurons[n], new Neuron(inputs.length));
  }*/

    
  float[] forward(float[] inputs){
    this.inputs = inputs;
    
    float[] layerValues = new float[0];
    
    for(int layer=0; layer<layers.length; layer++){
      if(layer==0) layerValues = layers[layer].forward(inputs);
       else layerValues = layers[layer].forward(layerValues);
    }
    
    return layerValues;
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
  
  void newWeights(float[][][] weights){
    
    for(int layer=0; layer<layers.length; layer++){
      layers[layer].newWeights(weights[layer]);
    }
    
  }
  
  /*
  float[] getAnswersFromLayer(int layer){
    if(layer==-1) layer = layers.length-1;
     else layer-=1;
    
    return layers[layer].getAnswers(); 
  }*/
  
  
  
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
         else text(layers[layer-1].getAnswer(neuron),x,y0+e*neuron);
      }
      
    }
    
       
  }

}


class Train
{
  Network network;
  
  float[][] inputs;     //X : valeurs d'entrée pour chaque exemple
  float[][] outputs;    //Y : valeurs de sortie pour chaque exemple
  
  float[][][] weights;  //Valeur extraite du network : les poids de chaque neurone de chaque couche
  
  float[][][] sums;     //Somme de chaque neurone de chaque couche avant fonction d'activation
  float[][][] answers;  //Somme de chaque neurone de chaque couche après fonction d'activation
  
  
  Train(Network n, float[][] i, float[][] o){
    network = n;
    inputs = i;
    outputs = o;
    
    weights = n.getAllWeights();
    
    //showArray(weights[0]);
  }
  
  void train(){
    
    float[][][] dJdW = costFunctionPrime(); 
    
    int scalar=10;
    
    for(int layer=0; layer<network.layers.length; layer++){
      
      //showArray(weights[layer]);
      
      weights[layer] = mSub(weights[layer], mT(mProduct(dJdW[layer],scalar)) );
      
      //showArray(weights[layer]);
      
      //println();
    }
    
    network.newWeights(weights);
    
    
  }
  
  float cost(){
    float J=0;
    
    for(int e=0; e<inputs.length; e++){
      J += network.cost(inputs[e],outputs[e]);
    }
    
    return 0.5*J;
  }
  
  float[][][] costFunctionPrime(){
    
    processExamples();  //New sums and answers
    
    int nLayer = network.layers.length;
    
    float[][][] delta = new float[nLayer][][];
    float[][][] dJdW = new float[nLayer][][];
    
    //Last layer dJdW :
    int n = nLayer-1;
    delta[n] = mProduct( (mInv(mSub(outputs,getAnswersFromLayer(n)))), sigmoidPrime(getSumsFromLayer(n)) );
    dJdW[n] = mDot( mT(getAnswersFromLayer(n-1)), delta[n]);    
    
    for(int layer = n-1; layer>=0; layer--){
      delta[layer] = mProduct( mDot(delta[layer+1], (weights[layer+1])), sigmoidPrime(getSumsFromLayer(layer)));
      dJdW[layer]  = mDot(mT(getAnswersFromLayer(layer-1)), delta[layer]);
    }
    
    return dJdW;
    
  }
  
    
  
  void processExamples(){
     
    sums = new float[inputs.length][][];
    answers = new float[inputs.length][][];
    
    for(int e=0; e<inputs.length; e++){  //Pour chaque exemple    
      network.forward(inputs[e]);
      
      sums[e] = network.getAllSums();
      answers[e] = network.getAllAnswers();
    }
    
  }
  
  float[][] getSumsFromLayer(int layer){  //TODO : à revoir (pas très optimisé)
    float[][] s = new float[answers.length][]; 
    for(int e=0; e<answers.length; e++) s[e] = sums[e][layer];
    return s;  
  }
  
  float[][] getAnswersFromLayer(int layer){  //TODO : à revoir (pas très optimisé)
    if(layer == -1) return inputs; //inputs
    
    float[][] ans = new float[answers.length][]; 
    for(int e=0; e<answers.length; e++) ans[e] = answers[e][layer];
    return ans;  
  }
  
  
  
}