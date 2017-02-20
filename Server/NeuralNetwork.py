# -*- coding: utf-8 -*-
"""
Created on Fri Jan 13 14:48:14 2017

@author: x.jannin
"""

import numpy as np
from math import exp
#from random import randrange, shuffle


def identity(x):
    return x
def identityPrime(x):
    return 1.

def relu(x):
    return max(0.,x)
def reluPrime(x):
    if x<=0: return 0.
    return 1.

def sigmoid(x):
    return 1/(1+exp(-x))
def sigmoidPrime(x):
    return (1-sigmoid(x))*sigmoid(x)

def tanh(x):
    return (exp(x)-exp(-x)) / (exp(x)+exp(-x))
def tanhPrime(x):
    return pow(2./(exp(x)+exp(-x)), 2)


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


learning_rate = 1e0
reg = 1e-3

#np.random.seed(100)

class Network:

    def __init__(self, layers, activs, trainSet = []):
        self.num_layers = len(layers)
        self.layers = layers
        
        #self.biases = [0.01*np.random.randn(1, y) for y in layers[1:]]
        self.weights = [0.01*np.random.randn(x, y) for x, y in zip(layers[:-1], layers[1:])]
        self.biases = [np.zeros((1,y)) for y in layers[1:]]
                       
        self.f = [activation[f] for f in activs]
        self.fPrime = [activationPrime[f] for f in activs]

        self.trainSet = trainSet

        self.hidden = []


    def forward(self, X):
        Y = X
        self.hidden = [X]
        for w,b,f in zip(self.weights, self.biases, self.f):
            Y = Y.dot(w) + b
            Y = f(Y)
            self.hidden.append(Y)

        return Y


    def train_step(self):
        batch = np.array(self.trainSet[0])  #Récupère les entrées des exemples
        answers = self.trainSet[1]  #Récupère la position de la bonne sortie des exemples

        scores = self.forward(batch)  #Sorties obtenues sur les exemples testés
        exp_scores = np.exp(scores)

        probs = exp_scores / np.sum(exp_scores, axis=1, keepdims=True)
        correct_logprobs = -np.log(probs[range(len(answers)),answers])

        data_loss = np.sum(correct_logprobs) / len(answers)
        #print(scores,probs, data_loss)
        reg_loss = 0.5 * reg * np.sum([np.sum(w*w) for w in self.weights])  #Somme de tous les poids

        loss = data_loss + reg_loss

        dscores = probs
        dscores[range(len(answers)),answers] -= 1
        dscores /= len(answers)
        
        dW, dB = [], []
        dh = dscores
        
        for i in reversed(range(len(self.layers)-1)):
            dh = dh * self.fPrime[i](self.hidden[i+1])
            
            dW.insert(0, np.dot(self.hidden[i].T, dh))
            dB.insert(0, np.sum(dh, axis=0, keepdims=True))
            
            if i>0:
                dh = np.dot(dh,self.weights[i].T)
        

        for w, dw, b, db in zip(self.weights, dW, self.biases, dB):
            w -= learning_rate * (dw + reg * w)
            b -= learning_rate * (db + reg * b)
        
    
        
        return loss


        """ # SVM
    def train_step(self, minibatch = False):

        batch = np.array([item[0] for item in self.trainSet])  #Récupère les entrées des exemples
        answers = [item[1] for item in self.trainSet]  #Récupère la position de la bonne sortie des exemples

        scores = self.forward(batch)  #Sorties obtenues sur les exemples testés

        margins = []
        for s, a in zip(scores,answers):
            m = np.maximum(0, s - s[a] + 1)
            m[a] = 0
            margins.append(np.sum(m))

        data_loss = np.sum(margins) #/ !! len(margins) !!

        reg_loss = 0
        #reg_loss = np.sum(np.absolute(self.weights))
        #reg_loss = np.sum(self.weights**2)

        loss = data_loss + reg_loss

        print(loss)


        #dmargins
        #dscores
        #dW


        dscores

        self.weights -= dW * learning_rate
        """


    def accuracy(self):
        examples = np.array(self.trainSet[0])
        correct_answers = self.trainSet[1]

        answers = self.forward(examples)

        correct = 0.;
        total = len(answers)
        for i in range(total):
            a = np.argmax(answers[i])   #Récupère la position de la valeur maximale
            if a == correct_answers[i]:
                correct += 1.

        return correct/total


"""
X = np.array([ [0,0,1],[0,1,1], [1,0,1], [0,0,1] ])
W = [np.full((3,4), 0.5), np.full((4,4), 0.2)]
"""

"""
X = []
for i in range(100):
    X.append([randrange(0,100,2)])    #Pair
    X.append([randrange(1,100,2)])    #Impair
shuffle(X)

y = []
for n in X:
    if n[0]%2 == 0:
        y.append(0)
    else:
        y.append(1)
"""

#np.random.seed(100)

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

n = Network(l,['relu','id'], train)


for i in range(10000):
    l = n.train_step()
    if i%1000==0:
        print(i,l,n.accuracy())



print(n.accuracy())



"""
plt.pcolor(data)
plt.colorbar()
plt.show()

"""
