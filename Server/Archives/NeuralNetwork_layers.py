# -*- coding: utf-8 -*-
"""
Created on Sat Jan 28 16:00:36 2017

@author: Xavier
"""

import numpy as np
from math import exp
from random import randrange, shuffle


#np.random.seed(100)

def identity(x):
    return x
def identityPrime(x):
    return 1

def relu(x):
    return max(0,x)
def reluPrime(x):
    if x>0: return 1
    return 0

def sigmoid(x):
    return 1/(1+exp(-x))
def sigmoidPrime(x):
    return (1-sigmoid(x))*sigmoid(x)

def tanh(x):
    return (exp(x)-exp(-x)) / (exp(x)+exp(-x))
def tanhPrime(x):
    return pow(2/(exp(x)+exp(-x)), 2)


activation = { 'id': np.vectorize(identity),
               'relu': np.vectorize(relu),
               'sigmoid': np.vectorize(sigmoid),
               'tanh': np.vectorize(tanh)
             }

activationPrime = { 'id': np.vectorize(identityPrime),
                    'relu': np.vectorize(reluPrime),
                    'sigmoid': np.vectorize(sigmoidPrime),
                    'tanh': np.vectorize(tanhPrime)
                  }
                  
                  

class Layer:
    
    def __init__(self, neurons, inputs, f='relu', b=False):
        
        self.nNeurons = neurons
        self.nInputs = inputs
        
        self.weights = 0.01*np.random.randn(inputs, neurons)
        self.biases = np.zeros((1,neurons))

        self.f = activation[f]
        self.fPrime = activationPrime[f]
        
        self.inputs = []
        self.outputs = []

        self.learning_rate = 1e-0
        self.reg = 1e-3
        
    

    def forward(self, X):
        W = self.weights
        b = self.biases
        
        Y = X.dot(W) + b
        Y = self.f(Y)
        
        #save:
        self.inputs = X
        self.outputs = Y
        
        return Y
        
        
    def backpropagation(self, dhidden):
        i = self.inputs
        W = self.weights
        b = self.biases
        
        fPrime = self.fPrime
        reg = self.reg
        learning_rate = self.learning_rate
        
        
        dW = np.dot(i.T, dhidden)
        db = np.sum(dhidden, axis=0, keepdims=True)
        
        dh = np.dot(dhidden,W.T)
        dh = fPrime(dh)
        
        dW += reg * W
        #print('W: ',W)
        W -= learning_rate * dW
        b -= learning_rate * db
        #print('w:',self.weights)
        return dh


        
class Network:
    
    def __init__(self, layers, f = 'relu', trainSet = 0, testSet = 0):
        
        self.nInputs = layers[0]
        self.nOuputs = layers[-1]
        
        self.layers = []
        for l in layers[1:]:
            self.addLayer(l)
        
        self.trainSet = []    #Exemples
        self.loadTrain = False
        if trainSet != 0:
            self.loadTrain = True
            self.trainSet = trainSet
        
        self.testSet = []
        self.loadTest = False
        if testSet != 0:
            self.loadTest = True
            self.testSet = testSet

    

    def __str__(self):
        return 

        
    def addLayer(self, n, f='relu', b=False):
        if len(self.layers) == 0 : i=self.nInputs
        else: i=self.layers[-1].nNeurons

        self.layers.append(Layer(n,i,f,b))
    
        
    def forward(self, X):
        if isinstance(X, type([])):
            X = np.array(X)
            
        Y = X
        for l in self.layers:
            Y = l.forward(Y)

        return Y
    

    def train_step(self):
        
        batch = np.array(self.trainSet[0])  #Récupère les entrées des exemples
        answers = self.trainSet[1]  #Récupère la position de la bonne sortie des exemples
    
        scores = self.forward(batch)  #Sorties obtenues sur les exemples testés
        exp_scores = np.exp(scores)        
        
        probs = exp_scores / np.sum(exp_scores, axis=1, keepdims=True)
        correct_logprobs = -np.log(probs[range(len(answers)),answers])
        
        data_loss = np.sum(correct_logprobs) / len(answers)
        
        #reg_loss = 0.5 * reg * np.sum([np.sum(w*w) for w in self.weights])  #Somme de tous les poids

        loss = data_loss #+ reg_loss
        
        dscores = probs
        dscores[range(len(answers)),answers] -= 1
        dscores /= len(answers)
        
        dh = dscores
        
        for layer in self.layers[::-1]:
            dh = layer.backpropagation(dh)
        
        
        
        return loss


        
    def accuracy(self, batch = 'testSet'):
        if batch=='train' and self.loadTrain or batch=='test' and self.loadTest :
            print('no data !')
            return 0
            
        examples = []
        correct_answers = []

        if batch=='trainSet':
            examples = np.array(self.trainSet[0])
            correct_answers = self.trainSet[1]
        elif batch=='testSet':
            examples = np.array(self.testSet[0])
            correct_answers = self.testSet[1]
        elif type(batch) == type([]):
            examples = np.array(batch[0])
            correct_answers = batch[1]

        answers = self.forward(examples)

        correct = 0
        total = len(answers)
        for i in range(total):
            a = np.argmax(answers[i])   #Récupère la position de la valeur maximale
            if a == correct_answers[i]:
                correct += 1

        return correct/total, correct

        
        
X = []
for i in range(100):
    X.append([randrange(0,1000,2)])    #Pair
    X.append([randrange(1,1000,2)])    #Impair
shuffle(X)

y = []
for n in X:
    if n[0]%2 == 0:
        y.append(0)
    else:
        y.append(1)

        
train = [X,y]
        

X = [[0,0,0,0],[0,0,0,1],[0,0,1,0],[0,0,1,1],[0,1,0,0],[0,1,0,1],
     [0,1,1,0],[0,1,1,1],[1,0,0,0],[1,0,0,1]]
y = [0,1,0,1,0,1,0,1,0,1]

train = [X,y]


N = 100 # number of points per class
D = 2 # dimensionality
K = 3 # number of classes
X = np.zeros((N*K,D)) # data matrix (each row = single example)
y = np.zeros(N*K, dtype='uint8') # class labels
for j in range(K):
  ix = range(N*j,N*(j+1))
  r = np.linspace(0.0,1,N) # radius
  t = np.linspace(j*4,(j+1)*4,N) + np.random.randn(N)*0.2 # theta
  X[ix] = np.c_[r*np.sin(t), r*np.cos(t)]
  y[ix] = j

train = [X,y]






      
l = [2,100,3]

n = Network(l, trainSet = train)




print(n.accuracy('trainSet'))

for i in range(1000):
    t = n.train_step()
    if i%100==0:
        print(t)


#print(n)





