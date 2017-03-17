
console.log('Server is starting...');

var express = require('express');
var bodyParser = require('body-parser');
var spawn = require("child_process").spawn;

var app = express();
var server = app.listen(80);

app.use(express.static('..'));
app.use(bodyParser.urlencoded({extended: false}));
app.use(bodyParser.json());


// Digit Recognition answer :
app.post('/digit_recognition', function(request, response){
  var image = request.body['image[]'];
  //console.log(image);
  var ip = request.connection.remoteAddress;
  var nav = request.headers['user-agent']
  var time = new Date().toString();
  console.log(ip + '\n' + time + '\n' + nav);

  //Lance le programme python avec image en paramètre:
  var process = spawn('python',["digit_recognition.py", image/*, layers*/]);

  var reply = {};
  //Traite la réponse reçue par le programme python:
  process.stdout.on('data', function (data){
    var answer = data.toString();  //hex to ASCII
    answer = JSON.parse(answer);  //ASCII to Object
    console.log('answer: ' + answer.answer + '\n');
    reply = answer;
    response.send(reply); //Envoie la réponse
  });

});


//Firebase:
var fs = require('fs');
var config = JSON.parse(fs.readFileSync('config.json'));

var firebase = require('firebase');
firebase.initializeApp(config);

var database = firebase.database();

app.post('/saveImage', function(request, response){
  var image = request.body['image[]'];
  var answer = request.body.answer;
  var ip = request.connection.remoteAddress;
  var time = new Date().toString();

  // Compression de l'image: ([21,0,0,0,0,64] -> [21,'0',64])
  var newImage = [], i=0; //Compte les zéros
  while(i<image.length){
    n = 0; while(image[i]=='0' && i<image.length){i++; n++;}
    if(n<=1) newImage.push(Number(image[i]));
    else newImage.push(String(n));
    i++;
  }

  var data = {
    image: newImage,
    digit: answer,
    ip: ip,
    time: time
  }

  //Enregiste l'image
  var ref = database.ref('images');
  ref.push(data, function(error){
    console.log(error)
  });

  //Mise à jour du compteur
  ref = database.ref('digits');
  ref.once('value', function(data){
    d = data.val();
    d[answer]++;
    database.ref('digits').set(d);
  },function(error){
    console.log(error);
  })


  console.log('New image saved !\n' + ip + '\n' + time + '\n');

  var reply = {
    answer: 'Image and answer saved !'
  };
  response.send(reply);
});
