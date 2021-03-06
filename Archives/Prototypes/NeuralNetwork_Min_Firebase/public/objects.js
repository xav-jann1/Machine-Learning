
function Neuron(nInputs) {
  this.weights = []
  for (var i = 0; i < nInputs; i++) this.weights.push(0.5);

  this.sum = 0;
  this.output = 0;

  this.forward = function(inputs) {
    this.sum = 0;
    for (var i = 0; i < inputs.length; i++)
      this.sum += inputs[i] * this.weights[i];
    this.output = this.sum;
    return this.sum;
  }
  
  this.getAnswer = function() { return this.sum; }
  
}


function Layer(nNeurons, nInputs) {
  this.neurons = [];
  for (var neuron = 0; neuron < nNeurons; neuron++) this.neurons.push(new Neuron(nInputs));

  this.forward = function(inputs) {
    var outputs = [];
    for (var neuron = 0; neuron < this.neurons.length; neuron++) {
      outputs.push(this.neurons[neuron].forward(inputs));
    }
    return outputs;
  }
  
  this.nNeurons = function(){ return this.neurons.length; }
  
  this.getAnswer = function(n){ return this.neurons[n].getAnswer(); }

}


function Network(i, n, o) {
  this.inputs = [];

  this.layers = [];
  this.layers.push(new Layer(n[0], i));   //Add 1st layer with inputs
  for (var layer = 1; layer < n.length; layer++) {
    this.layers.push(new Layer(n[layer], n[layer - 1]));
  }
  this.layers.push(new Layer(o, n[this.layers.length - 1]));  //Add output layer


  this.forward = function(inputs) {
    this.inputs = inputs;
    var layerInputs = inputs;
    for(var layer=0; layer<this.layers.length;layer++){
      layerInputs = this.layers[layer].forward(layerInputs);
    }
    return layerInputs;
  }
  
  
  this.display = function(w,h,rC){
    
    w-=rC; h-=rC;
    translate(rC/2 + w/2, rC/2 + h/2);  //Enlève l'espace occupé par les rayons des cercles et centre au milieu
    
    //Ajout des couches :
    var neuronsInLayer = [this.inputs.length-1]; //inputs.length-1};
    
    for(var l=0; l<this.layers.length; l++) neuronsInLayer.push(this.layers[l].nNeurons()-1);
    
    var e = h/max(neuronsInLayer);  //Ecart standard entre les cercles défini par la 'couche' ayant le plus de cercles
    var nLayers = neuronsInLayer.length;
    
    //stroke(0); strokeWeight(1);
    textAlign(CENTER,CENTER); textSize(12);
    
    for(var layer=0; layer<nLayers; layer++){ 
      var x = w/(nLayers-1)*(layer-(nLayers-1)/2);  //Position x de la couche
      var y0 = -e*neuronsInLayer[layer]/2;          //Position du 1er neurone en haut
      var  y1=0; if(layer<nLayers-1) y1 = -e*neuronsInLayer[layer+1]/2;    //Position y de la couche suivante
      
      for(var neuron=0; neuron <= neuronsInLayer[layer]; neuron++){  //Neurones de la couche
        
        //Lignes qui se relient à la couche suivante :
        if(layer<nLayers-1){  //La dernière couche n'a pas de couche suivante !
          for(var nextNeuron=0; nextNeuron <= neuronsInLayer[layer+1]; nextNeuron++){
            //getWeightLine();
            line(x,y0+e*neuron,x+w/(nLayers-1),y1+e*nextNeuron);
          }
        }
        
        //Neurone :
        fill(255);
        ellipse(x,y0+e*neuron,rC,rC);
        
        fill(0);  //Valeur du neurone
        
        if(layer===0){
          if(neuron > this.inputs.length-1) text("e",x,y0+e*neuron);
           else text(int(this.inputs[neuron]),x,y0+e*neuron);
        }else text(this.layers[layer-1].getAnswer(neuron),x,y0+e*neuron);
        
      }
      
    }
   
  }




}

