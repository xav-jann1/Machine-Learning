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

answer = {}
answer['answer'] = np.argmax(scores)

exp_scores = np.exp(scores)
probs = exp_scores / np.sum(exp_scores)

answer['scores'] = repr(probs)[6:-1]   #[6:-1] enlève 'array(' et ')'

print(JSONstringify(answer))  #Send data in JSON format
sys.stdout.flush()
