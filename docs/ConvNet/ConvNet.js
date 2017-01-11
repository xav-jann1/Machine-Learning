
function ConvNet(){

  this.layers = [];

  this.addLayer = function(type, param1, param2){
    var layer = {type: type};

    if(type=='conv'){
      layer.filters = this.createFilters(param1, param2);
      layer.width = param2;
    }else if(type=='pool'){
      layer.width = param1; //!!! : width = 2 dans pooling
      // ?:layer.stride =
      layer.take = param2;
    }else if(type=='relu'){
      layer.min = param1;
    }

    this.layers.push(layer);
  };

  this.forward = function(img){

    //TODO: vérifier si 'image' est une seule image ou un tableau d'image

    /*var data = {
      images: [image]
    };*/

    var images = [img];

    for(var l=0; l<this.layers.length; l++){
      var layer = this.layers[l];
      var nImages = images.length;  //Le nombre d'images peut changer

      console.log('layer', l, '-', layer.type);

      if(layer.type != 'fc'){

        for(var i=0; i<nImages; i++){
          var output = this.goToNextLayer(layer, images[i]);

          if(layer.type=='conv'){  //'conv' renvoie un tableau d'image
            images[i] = output[0];
            for(var e=1; e<output.length; e++) images.push(output[e]);
          }else images[i] = output;
        }

      }else{
        var newImage = [];

        for(var i=0; i<nImages; i++){
          for(var value=0; value<images[i].length; value++){
            newImage.push(images[i][value]);
          }

        }

        images = newImage;

      }
    }

    return images;
  };


  this.goToNextLayer = function(layer, image){
    switch(layer.type){
      case 'conv':
        //console.log(layer);
        return convolution(layer, image);

      case 'pool':
        return pooling(layer, image);

      case 'relu':
        return relu(layer, image);

      case 'fc':
        return fc(layer,image);

      default:
        console.log('error !!! : no layer');
    }

    return image;
  };


  this.createFilters = function(n, w){
    var filters = [];
    for(var f=0; f<n; f++){
      var filter = [];
      for(var i=0; i<w*w; i++){
        var r = getRandom(-1,1);
        //if(Math.abs(r)<1) r = Math.abs(r)+1;
        filter.push(r);
      }
      filters.push(filter);
    }
    return filters;
  };

}

function getRandom(min, max){  //Nombre aléatoire entre deux valeurs
  return Math.random()*(max-min) + min;
}

var conv = {
  type: 'conv',
  width: 3,
  filters : [ [] ]
};


function convolution(conv, image){

  var imageFilter = { //Rassemble les données pour le processus
    image: image,
    iWidth: Math.sqrt(image.length),  //Largeur de l'image
    fWidth: conv.width,  //Largeur du filtre
    padding: (conv.width-1)/2
  };

  var images = [];
  for(var f=0; f<conv.filters.length; f++){  //Pour chaque filtre:
    var filter = conv.filters[f];
    imageFilter.filter = filter;
    imageFilter.sumFilter = sumArray(filter);
    //console.log(imageFilter);
    var newImage = imageConv(imageFilter);
    images.push(newImage);
  }
  return images;
}


function imageConv(imageFilter){  // Calcul de l'image filtrée

  var iWidth = imageFilter.iWidth;
  var padding = imageFilter.padding;

  var newImage = [];
  //arrayCopy(image, newImage); //Récupère les dimensions de 'image'

  for(var y=padding; y<iWidth-padding; y++){
    for(var x=padding; x<iWidth-padding; x++){
      newImage.push(filterValue(x, y, imageFilter));
    }
  }

  return newImage;
}

function filterValue(x, y, imageFilter){  //Calcul de la valeur d'un pixel
  var image = imageFilter.image;
  var filter = imageFilter.filter;
  var sumFilter = imageFilter.sumFilter;

  var iWidth = imageFilter.iWidth;
  var fWidth = imageFilter.fWidth;
  var padding = imageFilter.padding;

  var sum = 0;
  for(var i=-padding; i<=padding; i++){
    for(var j=-padding; j<=padding; j++){
      var index = (x+j) + (y+i)*iWidth;
      var fIndex = (j+padding) + (i+padding)*fWidth
      sum += image[index] * filter[fIndex];
    }
  }

  //var sumFilter = filter.reduce((pv, cv) => Math.abs(pv)+Math.abs(cv), 0);  //Somme des poids du filtre
  sum /= sumFilter;

  // TODO : Vérifier s'il est nécessaire de contraindre les valeurs
  if(sum<0) sum = 0;
  if(sum>255) sum = 255;

  return sum;
}

function sumArray(array){
  var sum=0;
  for(var i=0; i<array.length; i++){
    sum+=array[i];
  }
  return sum;
}



function pooling(pool, image){
  var width = Math.sqrt(image.length);
  var pImage = {
    image: image,
    width: width
  };
  var newImage = [];
  for(var y=0; y<width; y+=2){
    for(var x=0; x<width; x+=2){
      newImage.push(pooli(x, y, pImage));
    }
  }
  return newImage;
}

function pooli(x, y, pImage){
  var image = pImage.image;
  var width = pImage.width;
  var max = image[x + y*width];                   //Haut-Gauche
  max = Math.max(max, image[x+1 + y*width]);      //Haut-Droite
  max = Math.max(max, image[x +(y+1)*width]);     //Bas-Gauche
  max = Math.max(max, image[x+1 + (y+1)*width]);  //Bas-Droite
  return max;
}


function relu(relu, image){
  var min = relu.min;

  for(var i=0; i<image.length; i++){
    if(image[i]<min) image[i]=min;
  }

  return image;
}

function fc(fc, image){


}
