
// Neural Network:
function neuralNetworkSetup(){

  var canvas = createCanvas(250, 250);
  canvas.parent('#p5-graph');

  var bias = select('#checkbox-1');
  bias.changed(newFieldNeuralStructure);

  var structureField = select('#neural-structure-field-value');
  structureField.value('2 3 1');
  displayNewNetwork([2,3,1], bias.checked());
  structureField.input(newFieldNeuralStructure);

}

//Example:
function exampleSetup(){

  loadExampleFile(exampleFile);

  var exampleCode = select('#example-code');
  var exampleData = select('#example-data');
  var buttonCode = select('#button-code');
  buttonCode.mousePressed( function(){
    showCode = !showCode;
    if(showCode){ //Code
      exampleCode.style('display:block');
      exampleData.style('display:none');

      select('#example-code-text').value(exampleText);
    }else{  //Data
      exampleCode.style('display:none');
      exampleData.style('display:block');

      exampleText = select('#example-code-text').value();
      loadExampleData(exampleText);
    }
  });

  //Save text :
  var buttonSaveCode = select('#button-example-code-save');
  buttonSaveCode.mousePressed(function(){
    var code = select('#example-code-text').value();
    var filename = JSON.parse(code).name;
    code = split(code, '\n');
    saveStrings(code, filename, 'json');
  });

  buttonNewExample = select('#button-newFile');
  buttonNewExample.mousePressed(function(){
    var answer = confirm("Créer un nouvel exemple ?");
    if(answer) {
      loadExampleFile(emptyFile);
      showToast('Nouvel exemple');
    }
  });


  //Drag and Drop:
  var dropzone = select('#example');
  dropzone.drop(function(data){
    var string = JSON.stringify(data.data); //data to String
    var splitSlice = split(string,",")[1].slice(0,-1);  //no 'base64,' and ' " ' at the end
    var decode = atob(splitSlice);  //base64 to String

    loadExampleText(decode);

    showToast('Exemple chargé : ' + data.name);

  }, unhighlight);
  dropzone.dragOver(function(){
    select('#icon-example-add').html("file_upload");
    dropzone.style('background-color: #EEE');
    select('#example-grid').style('background-color: #EEE');
    select('#example-drop-text').style('display: block');
  });
  dropzone.dragLeave(unhighlight);

  function unhighlight(){
    select('#icon-example-add').html("add");
    dropzone.style('background-color: ');
    select('#example-grid').style('background-color: #FAFAFA');
    select('#example-drop-text').style('display: none');
  }


}


//Neural Network functions :

function newFieldNeuralStructure(){
  var structureField = select('#neural-structure-field-value');
  var bias = select('#checkbox-1');

  var text = structureField.value();
  numbers = textToNumbers(text);

  if(numbers.length>=2){ //Minimum les entrées et sorties
    displayNewNetwork(numbers, bias.checked());
  }else console.log("! : il faut minimum 2 chiffres (>0)");
}

function textToNumbers(text){
  numbers = split(text,' ');  //Sépare les éléments du texte

  var onlyNumbers = true; //Trie des valeurs
  for(var i=numbers.length-1; i>=0; i--){
    if(numbers[i]=='') numbers.splice(i,1); //Supprime les éléments vide
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
  translate(2,2);
  n.display(width-4,height-4,28);
}


//Example functions :

function loadExampleFile(file){
  var text = loadStrings(file,function(){
    text = join(text, '\n');
    loadExampleText(text);
  });
}

function loadExampleText(text){
  loadExampleData(text);
  select('#example-code-text').value(text);
  exampleText = text; // ~return*/
}

function loadExampleData(data){ //data : String

  data = JSON.parse(data);  //String to JSON

  select('#example-name').html(data.name);

  select('#example-inputs').html(data.inputsName);
  select('#example-outputs').html(data.outputsName);

  if(data.inputsName.length==1)select('#example-inputs-text').html("Entrée :");
    else select('#example-inputs-text').html("Entrées :");
  if(data.outputsName.length==1)select('#example-outputs-text').html("Sortie :");
    else select('#example-outputs-text').html("Sorties :");

  select('#example-nExamples').html(data.examples.length);

  select('#example-structure').html(data.recommanded.structure);
  select('#example-activation').html(data.recommanded.activation);
  select('#example-rate').html(data.recommanded.rate);
  select('#example-bias').html(data.recommanded.bias);


  // TODO : Adapter l'affichage pour les exemples
  //select('#example-examples').html(data.examples);

}



function showToast(text){
  //Toast:
  var notification = document.querySelector('.mdl-js-snackbar');
  notification.MaterialSnackbar.showSnackbar({
    message: text
  });


}
