
console.log('Server is starting..');

var express = require('express');
var bodyParser = require('body-parser');

var app = express();
var server = app.listen(80);

app.use(express.static('../docs'));
app.use(bodyParser.urlencoded({extended: false}));
app.use(bodyParser.json());


var spawn = require("child_process").spawn;
app.post('/computePython', function(request, response){

  var data = request.body['data[]'];
  console.log(data);

  var process = spawn('python',["add data.py",data]); //Lance le program python avec data en paramètre

  var sum = 0;
  var reply = {
    answer: 'Message send !',
    sum: sum
  };

  process.stdout.on('data', function (data){
    sum = data.toString();
    console.log(sum);
    reply.sum = sum;  // TODO: Enlever le saut de ligne
    response.send(reply); //Envoie la réponse
  });

});

// Neural Network answer :
app.post('/neural-network', function(request, response){

  var data = request.body['data[]'];
  console.log('loading data..');

  //var process = spawn('python',["add data.py",data]); //Lance le program python avec data en paramètre
  /*
  var sum = 0;
  var reply = {
    answer: 'Message send !',
    sum: sum
  };

  process.stdout.on('data', function (data){
    sum = data.toString();
    console.log(sum);
    reply.sum = sum;  // TODO: Enlever le saut de ligne
    response.send(reply); //Envoie la réponse
  });*/

  var reply = {
    /*
    answer: 'Message send !',
    sum: 10, */

    iteration: 1,  //Nombre de fois que la boucle s'est éxécuté
    cost: 10,

    weights: [],  //Tous les poids du réseau

    examplesForward: []  //Réponse pour chaque exemple

  };

  response.send(reply);

});


// Convolutional Neural Network answer :
app.post('/convnet', function(request, response){
  var image = request.body['image[]'];
  //console.log(image);

  //Lance le program python avec image en paramètre:
  var process = spawn('python',["ConvNet.py", image/*, layers*/]);

  var reply = {};
  //Traite la réponse reçue par le programme python:
  process.stdout.on('data', function (data){
    console.log('answer:')
    var answer = data.toString();  //hex to ASCII
    console.log(answer);
    answer = JSON.parse(answer);  //ASCII to Object
    reply.answer = answer;
    response.send(reply); //Envoie la réponse
  });

/*
  var reply = {
    image: image,
    newImage: newImage
  };
*/

});
