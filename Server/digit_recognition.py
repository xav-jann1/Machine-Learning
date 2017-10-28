# -*- coding: utf-8 -*-
"""
Created on Sun Jan 29 09:40:10 2017

@author: Xavier
"""

import network, numpy as np, sys

def stringToArray(s):
    a = []
    n = s.split(',')
    for i in n:
        a.append(int(i))
    return a

def JSONstringify(dico):
    t = '{ '
    for key, value in zip(dico.keys(),dico.values()):
        t += '"' + key + '"' + ': ' + str(value) + ', '

    t = t[:-2]  #Enlève la dernière virgule
    t += ' }'

    return t

    
""" Sigmoide
#Network loading :
neurons = 100
n = network.Network([784, neurons, 10])
n.weights = np.load('data/' + str(neurons) + 'n - weights.npy')
n.biases  = np.load('data/' + str(neurons) + 'n - biases.npy')

#Get image and transform into an array :
a = sys.argv[1]  #Get 1st parameter
a = stringToArray(a)  #Create the array from the text

a = [[float(i)] for i in a]
a = np.array(a) / 255

#Forward :
scores = n.feedforward(a)
scores = [i[0] for i in scores]
"""

####### ReLU 
weights = np.load('data/npy/' + 'W - 0.9778.npy')
biases  = np.load('data/npy/' + 'b - 0.9778.npy')

W = weights[0]
W2 = weights[1]
b = biases[0]
b2 = biases[1]

#Get image and transform into an array :
a = sys.argv[1]  #Get 1st parameter
a = stringToArray(a)  #Create the array from the text

a = [[float(i)] for i in a]
X = np.array(a) / 255

hidden_layer = np.maximum(0, np.dot(X.T, W) + b) # note, ReLU activation
scores = np.dot(hidden_layer[0], W2) + b2
scores = [i for i in scores]
#######


answer = {}
answer['answer'] = np.argmax(scores)

exp_scores = np.exp(scores)
probs = exp_scores / np.sum(exp_scores)

answer['scores'] = repr(probs)[6:-1]   #[6:-1] enlève 'array(' et ')'

print(JSONstringify(answer))  #Send data in JSON format
sys.stdout.flush()
