p5.disableFriendlyErrors = true;
var n;
var structureField;
var button, answer
var activation, learning;
var bias;
function setup() {

  var canvas = createCanvas(250, 250);
  canvas.parent('p5-graph');

  bias = select("#checkbox-1");
  bias.changed(newFieldNeuralStructure);

  structureField = select("#neural-structure-field-value");
  structureField.value("2 3 1");
  displayNewNetwork([2,3,1], bias.checked());
  structureField.input(newFieldNeuralStructure);


  //button = select("#sendButton");
  //button.mousePressed(sendData);

  //answer = select("#answer");
  //answer.html(6);

  activation = select("#select-activation");
  learning = select("#select-learning");


  /*
  example.input(newExample);
  //loadExample('example name');
  console.log(example.value());
*/


}

function newExample(){
  console.log(example.value());
  //loadExample(example.value());
}

function loadExample(example){


}


function sendData(){
  console.log("Sending data ...");

  var data = {
    data: textToNumbers(structureField.value())  // TODO: Ajouter vérification
  };
  console.log(data);

  httpPost('/computePython',data,'json', dataPosted, postError);  //Envoie de la demande au serveur
}

function dataPosted(result){  //Réponse du serveur
  console.log(result.sum);
  answer.html(result.sum);
}

function postError(error){
  console.log(error);
}



function newFieldNeuralStructure(){
  var text = structureField.value();
  numbers = textToNumbers(text);

  if(numbers.length>=2){ //Minimum les entrées et sorties
    displayNewNetwork(numbers, bias.checked());
  }else console.log("! : il faut minimum 2 chiffres (>0)");
}

function textToNumbers(text){
  numbers = split(text," ");  //Sépare les éléments du texte

  var onlyNumbers = true; //Trie des valeurs
  for(var i=numbers.length-1; i>=0; i--){
    if(numbers[i]=="") numbers.splice(i,1); //Supprime les éléments vide
     else if(!int(numbers[i])){ //Vérfie si la valeur est bien un nombre (>0)
      onlyNumbers=false;
      break;
    }else numbers[i]=int(numbers[i]);
  }

  if(!onlyNumbers){ //Message d'erreur
    console.log("not only numbers !!");
    return false;
  }

  return numbers;
}

function displayNewNetwork(layers, bias){
  background(250);
  n = new Network(layers, bias);

  var inputs = [];  //Nombre d'inputs en fonction du nombre d'entrée
  for(var j=0; j<layers[0]; j++) inputs.push(1);

  n.forward(inputs);
  n.display(width,height,32);
}


function draw() {

}
