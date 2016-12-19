p5.disableFriendlyErrors = true;

var n;

var showCode = false;

var exampleFile = "examples/sin.json";
var emptyFile = "examples/empty.json";
var exampleText;

var button, answer;

function preload(){
  // Eviter d'utliser preload : appartion de texte dans structureField
  //example = loadJSON(exampleFile, loadExample);
  //exampleString = loadStrings(exampleFile);
}


function setup() {

  neuralNetworkSetup();

  exampleSetup();

  //learningSetup();


  //button = select('#sendButton');
  //button.mousePressed(sendData);

  //answer = select('#answer');
  //answer.html(6);


}


function sendData(){
  console.log('Sending data ...');

  var data = {
    data: textToNumbers(structureField.value())  // TODO: Ajouter vérification
  };
  console.log(data);

  httpPost('/computePython',data,'json', dataPosted, postError);  //Envoie de la demande au serveur
}

function dataPosted(result){  //Réponse du serveur
  console.log(result.sum);
  //answer.html(result.sum);
}

function postError(error){
  console.log(error);
}


function draw() {

}
