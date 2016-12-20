
console.log('Server is starting..');

var express = require('express');
var bodyParser = require('body-parser');

var app = express();
var server = app.listen(3010);

app.use(express.static('../docs/Neural Network'));
app.use(bodyParser.urlencoded({extended: false}));
app.use(bodyParser.json());


var spawn = require("child_process").spawn;
app.post('/computePython', function(request, response){

  var data = request.body['data[]'];
  //console.log(data);

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

    iteration: 1, //Nombre de fois que la boucle s'est éxécuté
    cost: 10,

    weights: [], //Tous les poids du réseau

    examplesForward: []  //Réponse pour chaque exemple



  };

  response.send(reply);



});
