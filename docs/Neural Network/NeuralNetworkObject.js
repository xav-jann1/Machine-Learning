
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


function Network(layers, bias) {

  this.bias = 0;
  if(typeof bias !== 'undefined') this.bias = int(bias);

  this.inputs = [];

  this.layers = [];
  //this.layers.push(new Layer(n[0], i));   //Add 1st layer with inputs
  for (var layer = 1; layer < layers.length; layer++) {
    this.layers.push(new Layer(layers[layer], layers[layer - 1] + bias));
  }
  //this.layers.push(new Layer(o, n[this.layers.length - 1]));  //Add output layer


  this.forward = function(inputs) {
    arrayCopy(inputs,this.inputs);

    var layerInputs = inputs;
    for(var layer=0; layer<this.layers.length;layer++){
      if(bias) layerInputs.push(1);
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
    if(bias) for(var i=0; i<neuronsInLayer.length-1; i++) neuronsInLayer[i]++;  //Ajoute un neurone pour chaque couche sauf la dernière

    var e = h/max(neuronsInLayer);  //Ecart standard entre les cercles défini par la 'couche' ayant le plus de cercles
    var nLayers = neuronsInLayer.length;

    //stroke(0); strokeWeight(1);
    textAlign(CENTER,CENTER); textSize(12);
    var neuronColor = ['#F44336','#2196F3','#4CAF50'];

    for(var layer=0; layer<nLayers; layer++){
      var x = w/(nLayers-1)*(layer-(nLayers-1)/2);  //Position x de la couche
      var y0 = -e*neuronsInLayer[layer]/2;          //Position du 1er neurone en haut
      var  y1=0; if(layer<nLayers-1) y1 = -e*neuronsInLayer[layer+1]/2;    //Position y de la couche suivante

      for(var neuron=0; neuron <= neuronsInLayer[layer]; neuron++){  //Neurones de la couche

        //Lignes qui se relient à la couche suivante :
        strokeWeight(2); stroke(100);
        if(layer<nLayers-1){  //La dernière couche n'a pas de couche suivante !
          for(var nextNeuron=0; nextNeuron <= neuronsInLayer[layer+1]; nextNeuron++){
            //getWeightLine();
            if(bias){
              if(nextNeuron<neuronsInLayer[layer+1] || layer==nLayers-2) line(x,y0+e*neuron,x+w/(nLayers-1),y1+e*nextNeuron);
            }else line(x,y0+e*neuron,x+w/(nLayers-1),y1+e*nextNeuron);
          }
        }

        //Neurone :
        fill(255); strokeWeight(3);
        if(layer==0) stroke(neuronColor[0]);  //Input
         else if(layer==nLayers-1) stroke(neuronColor[2]);  //output
          else stroke(neuronColor[1]);  //Inside
        ellipse(x,y0+e*neuron,rC,rC);

        fill(0);  //Valeur du neurone

        if(bias && layer<nLayers-1 && neuron == neuronsInLayer[layer]){
          noStroke();
          text(1,x,y0+e*neuron);
        }else{/*
          if(layer===0){
            if(neuron > this.inputs.length-1) text("e",x,y0+e*neuron);
             else text(int(this.inputs[neuron]),x,y0+e*neuron);
          }else text(this.layers[layer-1].getAnswer(neuron),x,y0+e*neuron);*/
        }
      }

    }

  }




}
