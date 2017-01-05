
var d = function(c){

  c.setup = function(){
    var divW = c.select('#draw').width;
    var divH = c.select('#draw').height;

    c.createCanvas(280,280);//divW, divH);

    c.noStroke();
    c.background(100);

    var buttonClear = c.createButton("clear")//.mousePressed(conv);
    buttonClear.mousePressed(function(){ //Test sur l'image
      c.background(100);
    });

  };

  c.mouseDragged = function(){  //Dessin de l'utilisateur
    c.fill(250);
    c.ellipse(c.touchX,c.touchY,40,40);

  };

  c.mouseReleased = function(){
    p5nd.img(c.get());  //Déclenche l'affichage de l'image pixelisé
  };




};
var myp5 = new p5(d,'draw');


var nd = function(c){

  c.setup = function(){

    var divW = c.select('#draw').width;
    var divH = c.select('#draw').height;

    c.createCanvas(280,280);//divW, divH);

    c.noStroke();
    c.background(100);



    var button = c.createButton("send")//.mousePressed(conv);
    button.mousePressed(function(){ //Test sur l'image

      var net = new ConvNet();
      //*
      net.addLayer('conv', 5, 5);
      net.addLayer('pool', 2);
      net.addLayer('conv', 2, 3);
      net.addLayer('conv', 2, 3);
      net.addLayer('pool', 2);
      net.addLayer('pool', 2);

      net.addLayer('relu', 50);

      net.addLayer('fc');
      
      //*/

      //sendImage(c.imgToArray(c.pixelImage));

      console.log(net.forward(c.imgToArray(c.pixelImage)));

    });
  };

  function sendImage(image){  //Image = Array
    console.log('Sending data...');

    var data = {
      image: image

      //layers:

    }
    console.log(data);

    c.httpPost('/convnet', data, 'json', function(result){
      //Server answer:
      console.log(result);

    }, function(error){ console.log(error); });

  }

  c.pixelImage;

  c.imgToArray = function(image){
    var array = [];
    var width = image.width;
    image.loadPixels();
    for(var i=0; i<width*width; i++) array.push(image.pixels[i*4]);
    return array;
  }


  c.img = function(image){
    var pixel = c.norm(image);  //Récupère l'image pixelisée

    var l = image.width/28;  //Dimension d'un pixel
    c.showImage(pixel, l);  //Affichage de l'image dans le canvas

    c.pixelImage = pixel; //Enregistre l'image
    //console.log(pixel);

  };

  c.showImage = function(image, l){
    image.loadPixels();
    for(var y=0; y<28; y++){
      for(var x=0; x<28; x++){
        var i = (x + y*28) * 4;
        var red = image.pixels[i];
        var green = image.pixels[i+1];
        var blue = image.pixels[i+2];

        c.fill(red, green, blue);
        c.rect(x*l,y*l,l,l);
      }
    }
  };

  c.norm = function(image){  //Normalise une image (28x28 px)

    var newImage = c.createImage(28, 28);
    newImage.loadPixels();

    for(var y=0; y<28; y++){
      for(var x=0; x<28; x++){
        var i = (x+y*28)*4;
        var pixColor = c.blockColorPixel(x,y,image);

        newImage.pixels[i] = pixColor[0];
        newImage.pixels[i+1] = pixColor[1];
        newImage.pixels[i+2] = pixColor[2];
        newImage.pixels[i+3] = 255;
      }
    }

    newImage.updatePixels();
    return newImage;
  };

  c.blockColorPixel = function(x, y, image){

    var iWidth = image.width;
    var nPixel = iWidth/28;
    x *= nPixel;
    y *= nPixel;

    var red = 0, green = 0, blue = 0;

    image.loadPixels();
    for(var i=0; i<nPixel; i++){
      for(var j=0; j<nPixel; j++){
        var px = ( (x+i) + (y+j)*(iWidth) )*4;
        red   += image.pixels[px];
        green += image.pixels[px+1];
        blue  += image.pixels[px+2];
      }
    }

    red /= nPixel*nPixel;
    green /= nPixel*nPixel;
    blue /= nPixel*nPixel;

    return [red, green, blue];
  }

};
var p5nd = new p5(nd,'norm-draw');
