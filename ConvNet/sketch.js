
var d = function(c){

  c.setup = function(){
    var divW = c.select('#draw').width;
    var divH = c.select('#draw').height;

    c.createCanvas(280,280);//divW, divH);

    c.noStroke();
    c.background(0);

    var buttonClear = c.createButton("clear")//.mousePressed(conv);
    buttonClear.mousePressed(function(){ //Test sur l'image
      c.background(0);
    });

  };

  c.mouseDragged = function(){  //Dessin de l'utilisateur
    c.fill(255);
    c.ellipse(c.touchX,c.touchY,25,25);

  };

  c.mouseReleased = function(){
    p5nd.img(c.get());  //Déclenche l'affichage de l'image pixelisé
  };




};
var myp5 = new p5(d,'draw');


var nd = function(c){
  var answer, scores = [];
  c.setup = function(){

    var divW = c.select('#draw').width;
    var divH = c.select('#draw').height;

    c.createCanvas(280,280);//divW, divH);

    c.noStroke();
    c.background(0);



    var button = c.createButton("send")//.mousePressed(conv);
    button.mousePressed(function(){ //Test sur l'image

      var net = new ConvNet();
      /*
      net.addLayer('conv', 5, 5);
      net.addLayer('pool', 2);
      net.addLayer('conv', 2, 3);
      net.addLayer('conv', 2, 3);
      net.addLayer('pool', 2);
      net.addLayer('pool', 2);

      net.addLayer('relu', 50);

      net.addLayer('fc');

      //*/

      var image = c.pixelImage;
      //console.log(c.pixelImage);

      for(var i=0; i<image.length; i++){
        image[i] = c.int(image[i]);
      }

      sendImage(image);

      //console.log(net.forward(c.imgToArray(c.pixelImage)));
      /*console.log(c.imgToArray(c.pixelImage));

      var data = c.imgToArray(c.pixelImage);
      var json = {img: data};
      //data = c.split(data, '\n');
      console.log(json)
      c.save(JSON.stringify(json), 'ijj', 'json');*/

    });

    answer = c.createP('wait');
    c.createP('scores :');
    console.log(scores);
    for(var i=0; i<10; i++) scores.push(c.createP(i+': '));
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
      answer.html('answer: ' + result.answer);
      s = result.scores;
      for(var i=0; i<10; i++) scores[i].html(i+': '+ s[i]);

    }, function(error){ console.log(error); });

  }


  c.pixelImage;

  c.img = function(image){
    var pixel = c.norm(image);  //Récupère l'image pixelisée

    pixel = c.centerImage(pixel);

    var l = image.width/28;  //Dimension d'un pixel
    c.showImage(pixel, l);  //Affichage de l'image dans le canvas

    c.pixelImage = pixel; //Enregistre l'image
    //console.log(pixel);

  };

  c.norm = function(image){  //Normalise une image (28x28 px) dans une liste
    var newImage = [];
    for(var y=0; y<28; y++){
      for(var x=0; x<28; x++){
        var pixColor = c.blockColorPixel(x,y,image);
        newImage.push(pixColor)
      }
    }
    return newImage;
  };

  c.blockColorPixel = function(x, y, image){
    var iWidth = image.width;
    var nPixel = iWidth/28;
    x *= nPixel; y *= nPixel;

    var grey = 0;
    image.loadPixels();
    for(var i=0; i<nPixel; i++){
      for(var j=0; j<nPixel; j++){
        var px = ( (x+i) + (y+j)*(iWidth) )*4;
        grey   += image.pixels[px];
      }
    }
    grey /= nPixel*nPixel;
    return grey;
  };


  c.showImage = function(image, l){
    for(var y=0; y<28; y++){
      for(var x=0; x<28; x++){
        var i = (x + y*28);
        var color = image[i];
        c.fill(color);
        c.rect(x*l,y*l,l,l);
      }
    }
  };

  c.centerImage = function(image){
    var dim = 28;
    var d = c.delta(image);

    var lx = d[3]-d[2];
    var ly = d[1]-d[0];

    var cx = (dim - lx)/2;  //Position x pour que l'image soit centré
    var dx = cx - d[2];   //Mouvement x pour centrer l'image
    image = c.moveX(image, dx);

    var cy = (dim - ly)/2;  //Position y pour que l'image soit centré
    var dy = cy - d[0];   //Mouvement y pour centrer l'image
    image = c.moveY(image, dy);

    console.log(lx, ly, dx,dy);

    return image;
  };

  c.moveX = function(image, dx){
    if(dx>0){ //Vers la droite
      for(var i=0; i<dx; i++){
        for(var y=0; y<28; y++){
          image.splice(y*28,0,0);    // Ajoute un pixel à gauche d'une ligne
          image.splice(y*28 + 28, 1);  // Enlève le pixel qui 'dépasse' de l'image
        }
      }
    }

    if(dx<0){
      dx = -dx;
      for(var i=0; i<dx; i++){
          for(var y=0; y<28; y++){
          image.splice(y*28 + 28,0,0); // Ajoute un pixel à gauche d'une ligne
          image.splice(y*28,1);        // Enlève le pixel qui 'dépasse' de l'image
        }
      }
    }

    return image;
  };

  c.moveY = function(image, dy){
    if(dy>0){ //Vers le bas
      for(var i=0; i<dy; i++){
        for(var j=0; j<28; j++){
          image.splice(0,0,0);
        }
        image = image.slice(0,784);
      }
    }

    if(dy<0){ //Vers le haut
      dy = -dy;
      for(var i=0; i<dy; i++){
        image = image.slice(28,784);  //Enlève ligne du haut
        for(var j=0; j<28; j++){  //Ajoute une ligne en bas
          image.splice(784-28,0,0);
        }
      }
    }

    return image;
  };

  c.delta = function(image){  //Donne l'occupation du dessin sur l'image
    var d=[], x, y, found, dim=28;

    //Haut :
    y = 0; found = false;
    while(y<dim && !found){
      for(x=0; x<dim; x++){
        var i = (y*dim + x);
        if(image[i]!=0) found = true;
      }
      if(!found) y++;
    }
    d.push(y);

    //Bas :
    y = dim-1; found = false;
    while(y>0 && !found){
      for(x=0; x<dim; x++){
        var i = (y*dim + x);
        if(image[i]!=0) found = true;
      }
      if(!found) y--;
    }
    d.push(y);

    //Gauche :
    x = 0; found = false;
    while(x<dim && !found){
      for(y=0; y<dim; y++){
        var i = (y*dim + x);
        if(image[i]!=0) found = true;
      }
      if(!found) x++;
    }
    d.push(x);

    //Droite :
    x = dim-1; found = false;
    while(x>0 && !found){
      for(y=0; y<dim; y++){
        var i = (y*dim + x);
        if(image[i]!=0) found = true;
      }
      if(!found) x--;
    }
    d.push(x);

    console.log(d);
    return d;
  };

};
var p5nd = new p5(nd,'norm-draw');
