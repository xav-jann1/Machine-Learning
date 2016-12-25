
from math import sqrt
from random import uniform

import sys


class ConvNet:

    def __init__(self):
        self.layers = []


    def addLayer(self, t, arg1, arg2 = 3):
        layer = {}
        layer['type'] = t;
        # ou layer = {'type: t'}

        if t == 'conv':
            layer['filters'] = self.createFilters(arg1, arg2)
            layer['width'] = arg2
        elif t == 'pool':
            layer['width'] = arg2
            #layer['stride'] =
        elif t == 'relu':
            layer['min'] = arg1

        self.layers.append(layer)

    def forward(self, img):
        images =  [] #Liste des images créées par convulation
        images.append(img)

        #print(images)

        for layer in self.layers:

            print('layer - ' + layer['type']);

            for i in range(len(images)):
                #Récupère l'image:
                image = images[i]

                #Sortie de la couche :
                output = self.layerOutput(layer, image)

                if layer['type'] == 'conv':   #'conv' renvoie un tableau d'image
                    images[i] = output[0]   #Remplace l'image utilisée
                    for e in range(1,len(output)):
                        images.append(output[e])
                else:
                    images[i] = output

        return images


    def layerOutput(self, layer, image):  # Redirection vers la fonction de la couche
        t = layer['type']

        if t == 'conv':
            return convolution(layer, image)
        if t == 'pool':
            return pooling(layer, image)
        if t == 'relu':
            return relu(layer, image)

        return image

    def createFilters(self, n, width):  # Créé 'n' filtres de dimensions 'width' par 'width' (1 filtre = suite de nombres)
        filtres = []    #Listes des filtres

        for f in range(n):
            filtre = []
            for i in range(width*width):
                filtre.append(0.5)#uniform(-1,1))

            filtres.append(filtre)

        print(filtres)
        return filtres


#Couches:
#Layer
def convolution(conv, image):
    imageFilter = {
        'image': image,
        'iWidth': int(sqrt(len(image))),
        'fWidth': conv['width'],
        'padding': int((conv['width']-1)/2)
    }

    images = []
    for filtre in conv['filters']:
        imageFilter['filter'] = filtre
        imageFilter['sumFilter'] = sum(filtre)
        newImage = imageConv(imageFilter)
        images.append(newImage)

    return images

def imageConv(imageFilter):
    iWidth = imageFilter['iWidth']
    padding = imageFilter['padding']

    newImage = []

    for y in range(padding, iWidth-padding):
        for x in range(padding, iWidth-padding):
            newImage.append(filterValue(x, y, imageFilter))

    return newImage

def filterValue(x, y, imageFilter):
    image = imageFilter['image']
    filtre = imageFilter['filter']
    sumFilter = imageFilter['sumFilter']
    iWidth = imageFilter['iWidth']
    fWidth = imageFilter['fWidth']
    padding = imageFilter['padding']

    s=0
    for i in range(-padding, padding+1):
        for j in range(-padding, padding+1):
            index = (x+j) + (y+i)*iWidth
            fIndex = (j+padding) + (i+padding)*fWidth
            s += image[index] * filtre[fIndex]

    s /= sumFilter

    # TODO : Vérifier s'il est nécessaire de contraindre les valeurs
    if s<0: s=0
    if s>255: s=255

    return s

#Layer
def pooling(pool, image):
    width = int(sqrt(len(image)))
    pImage = {'image': image, 'width': width}
    newImage = []

    for y in range(0, width, 2):
        for x in range(0, width, 2):
            newImage.append(pooli(x,y,pImage))

    return newImage

def pooli(x,y,pImage):  #Retourne le maximum dans une zone de l'image
    image = pImage['image']
    width = pImage['width']
    m = image[x + y*width]                  #Haut-Gauche
    m = max(m, image[x+1 + y*width])        #Haut-Droite
    m = max(m, image[x + (y+1)*width])      #Bas-Gauche
    m = max(m, image[x+1 + (y+1)*width])    #Bas-Droite
    return m

#Layer
def relu(relu, image):
    m = relu['min']
    for i in range(len(image)):
        if image[i] < m:
            image[i]=m
    return image



"""
net = ConvNet()

net.addLayer('conv',3,3)
#net.addLayer('relu',8)
#net.addLayer('pool',2)

image = [2,0,2,6,4,8,5,4,2,12,8,45,12,54,5,4]


print(net.forward(image))

"""
numbers = []
s = sys.argv[1]

numbers.append(s)
numbers.append(s)

print(numbers)
sys.stdout.flush()
