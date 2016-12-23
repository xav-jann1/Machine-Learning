
function ConvNet(){

  this.layers = [];

  this.addLayer = function(type, param1, param2){
    var layer = {type: type};

    if(type=='conv'){
      layer.filters = this.createFilters(param1, param2);
      layer.width = param2;
    }else if(type=='pool'){
      layer.width = param1;
      layer.take = param2;
    }else if(type=='relu'){
      layer.min = param1;
    }

    this.layers.push(layer);
  };

  this.forward = function(image){

    var data = {
      images: [image]
    };

    for(var l=0; l<this.layers.length; l++){
      var layer = this.layers[l];
      var nImages = data.images.length;  //Le nombre d'images peut changer

      console.log('layer', l, '-', layer.type);

      for(var i=0; i<nImages; i++){
        var image = data.images[i];
        image = this.goToNextLayer(layer, image);

        if(layer.type=='conv'){  //'conv' renvoie un tableau d'image
          data.images[i] = image[0];
          for(var e=1; e<image.length; e++) data.images.push(image[e]);
        }else data.images[i] = image;

      }
    }

    return data;
  };


  this.goToNextLayer = function(layer, image){
    switch(layer.type){
      case 'conv':
        return convolution(layer, image);

      case 'pool':
        return pooling(layer, image);

      case 'relu':
        return relu(layer, image);

      default:
        console.log('error !!! : no layer');
    }

    return image;
  };

  this.createFilters = function(n, w){
    var filters = [];
    for(var f=0; f<n; f++){
      var filter = [];
      for(var i=0; i<w*w; i++) filter.push(getRandom(-1,1));
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

var pool = {
  type: 'pool',
  width: 2,
  take: 'max' // ou 'min'
};
/*
var relu = {
  type: 'relu',
  min: 0
};*/



function convolution(conv, image){

  var images = [];

  for(var f=0; f<conv.filters.length; f++){ //Pour chaque filtre:
    var filter = conv.filters[f];
    var newImage = newImage = imageConv(image, filter);

    images.push(newImage);
  }

  return images;
}


function imageConv(image, filter){  // Calcul de l'image filtrée

  var iWidth = Math.sqrt(image.length);
  var fWidth = Math.sqrt(filter.length);
  var padding = (fWidth-1)/2;

  var newImage = [];
  //arrayCopy(image, newImage); //Récupère les dimensions de 'image'

  for(var y=padding; y<iWidth-padding; y++){
    for(var x=padding; x<iWidth-padding; x++){
      newImage.push(filterValue(x, y, image, filter));
    }
  }

  return newImage;
}

// TODO: filter comme objet pour intégrer 'width' et 'padding' (plus besoin de calculer)
function filterValue(x, y, image, filter){  //Calcul de la valeur d'un pixel
  var width = Math.sqrt(image.length);
  var fWidth = Math.sqrt(filter.length)
  var padding = ( fWidth - 1) / 2;

  var sum = 0;
  for(var i=-padding; i<=padding; i++){
    for(var j=-padding; j<=padding; j++){
      var index = (x+j) + (y+i)*width;
      sum += image[index] * filter[(i+padding)*fWidth + (j+padding)];
    }
  }

  var sumFilter = filter.reduce((pv, cv) => pv+cv, 0);  //Somme des poids du filtre
  sum /= sumFilter;

  return sum;
}









function pooling(pool, image){



}

function relu(relu, image){ // ! : copie de tableau ?
  var min = relu.min;

  for(var i=0; i<image.length; i++){
    if(image[i]<min) image[i]=min;
  }

  return image;
}
