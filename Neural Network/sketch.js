p5.disableFriendlyErrors = true;

var n;

var showCode = false;

var exampleFile = "examples/sin.json";
var emptyFile = "examples/empty.json";
var exampleText;

function preload(){
  // Eviter d'utliser preload : appartion de texte dans structureField
  //example = loadJSON(exampleFile, loadExample);
  //exampleString = loadStrings(exampleFile);
}


function setup() {

  neuralNetworkSetup();

  exampleSetup();

  //learningSetup();


  var button = select('#sendButton');
  button.mousePressed(newLearning); //*/

  //var answer = select('#answer');
  //answer.html(6);


}


function newLearning(){

  console.log('Sending data...');

  var exampleText = select('#example-code-text').value(); //Récupère les données de l'exemple
  var exampleData = JSON.parse(exampleText);

  var data = {
    name: exampleData.name,
    structure: textToNumbers(select("#neural-structure-field-value").value()),
    activation: select("#select-activation").value(),
    //rate: select("#"),
    bias: select('#checkbox-1').checked(),

    examples: exampleData.examples

  };

  console.log(data.structure);

  //httpPost('/neural-network', data, 'json', function(result){
  httpPost('/computePython', data.structure, 'json', function(result){
    //Server answer:
    console.log(result);

  }, function(error){
    console.log(error);
  });

}


function draw() {

}
