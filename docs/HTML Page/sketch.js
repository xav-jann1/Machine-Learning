p5.disableFriendlyErrors = true;
var n;
var structureField
function setup() {

  var canvas = createCanvas(250, 250);
  canvas.parent('p5-graph');

  structureField = select("#neural-structure-field-value");
  structureField.value("2 3 1");
  structureField.input(newFieldNeuralStructure);


  displayNewNetwork([2,3,1]);

}


function newFieldNeuralStructure(){

  numbers = split(structureField.value()," ");  //Sépare les éléments du texte récupéré

  var onlyNumbers = true; //Trie des valeurs
  for(var i=numbers.length-1; i>=0; i--){
    if(numbers[i]=="") numbers.splice(i,1); //Supprime les éléments vide
     else if(!int(numbers[i])){ //Vérfie si la valeur est bien un nombre (>0)
      onlyNumbers=false;
      break;
    }else numbers[i]=int(numbers[i]);
  }

  if(numbers.length<2 || !onlyNumbers){ //Message d'erreur
    console.log("! : il faut minimum 2 chiffres (>0)");
    return ;
  }

  //var i = numbers[0];
  //var o = numbers.pop();  //Supprime et récupère la dernière valeur
  //numbers.splice(0,1);  //Enlève la première valeur -> numbers ne contient plus la 1ère et dernière valeur
  //var n = numbers;

  displayNewNetwork(numbers);


}

function displayNewNetwork(layers){
  background(250);
  n = new Network(layers);

  var inputs = [];  //Nombre d'inputs en fonction du nombre d'entrée
  for(var j=0; j<layers[0]; j++) inputs.push(1);

  n.forward(inputs);
  n.display(width,height,32);
}

function draw() {


}
