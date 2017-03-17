var database;
var config = {
  apiKey: "AIzaSyD9m1EKuam3YBazeVILj0QFbTrS-7DqUcE",
  authDomain: "digit-recognition-d625f.firebaseapp.com",
  databaseURL: "https://digit-recognition-d625f.firebaseio.com",
  storageBucket: "digit-recognition-d625f.appspot.com",
  messagingSenderId: "718889875920"
};

var l=10, index = 0;
var textDigit, number;
function setup() {
  createCanvas(28*l,28*l);

  //Firebase:
  firebase.initializeApp(config);
  database = firebase.database();

  var ref = database.ref('images');
  ref.on('value', function(data){
    data = data.val();

    images = [];
    var keys = Object.keys(data);
    console.log(keys);
    for(var i=0; i<keys.length; i++){
      var key = keys[i];
      images.push(data[key]);
    }

    if(index >= images.length) index = images.length-1;
    update(images[index]);

  }, function(error){ console.log(error); });


  var bBack = createButton('Back');
  bBack.mousePressed(function(){
    index--; if(index<0) index = images.length-1;
    update(images[index]);
  });
  
  var bNext = createButton('Next');
  bNext.mousePressed(function(){
    index++; if(index>=images.length) index = 0;
    update(images[index]);
  });



  textDigit = createP('digit:');
  number = createP('index:');



}

function update(image){
  textDigit.html('digit: ' + image.digit);
  number.html('index: ' + index + ' / ' + (images.length-1));
  drawImage(image.image);
}

function drawImage(array){

  //Uncompressed data:
  var image = [];
  for(var i=0; i<array.length; i++){
    var p = array[i];
    if(typeof p === 'number') image.push(p);
    else{ //String
      var n = Number(p);
      for(var j=0; j<n; j++) image.push(0);
    }
  }

  //Display image:
  for(var y=0; y<28; y++){
    for(var x=0; x<28; x++){
      var i = (x + y*28);
      var color = image[i];
      fill(color);
      rect(x*l,y*l,l,l);
    }
  }

}
