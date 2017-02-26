# -*- coding: utf-8 -*-
"""
Created on Sun Jan 29 14:31:42 2017

@author: Xavier
"""

import os
from decimal import Decimal

import numpy as np

import cPickle
import gzip

def load_data():
    f = gzip.open('data/mnist.pkl.gz', 'rb')
    training_data, validation_data, test_data = cPickle.load(f)
    f.close()
    return (training_data, test_data)

def compare(i,j):
    k=j[0]-i[0]
    if k<0:
        return 1
    if k>0:
        return -1
    return 0
   
def accuracy():

        correct_answers = y
        
        hidden_layer = np.maximum(0, np.dot(X, W) + b) # note, ReLU activation
        answers = np.dot(hidden_layer, W2) + b2

        correct = 0.;
        total = len(answers)
        for i in range(total):
            a = np.argmax(answers[i])   #Récupère la position de la valeur maximale
            if a == correct_answers[i]:
                correct += 1.

        return correct/total


N = 500 # number of points per class
D = 784 # dimensionality
K = 10 # number of classes

print 'load data..'
training_data, test_data = load_data()

X = training_data[0]
y = training_data[1]

print 'data loaded !' + '\n'


f = open('learning.txt','w')


# initialize parameters randomly
h = 100 # size of hidden layer
W = 0.01 * np.random.randn(D,h)
b = np.zeros((1,h))
W2 = 0.01 * np.random.randn(h,K)
b2 = np.zeros((1,K))


# some hyperparameters
step_size = 5e-1
reg = 1e-3 # regularization strength

minLoss = [[2,0,W,b,W2,b2] for i in range(5)]

# gradient descent loop
num_examples = X.shape[0]
for i in xrange(10000):
  
  # evaluate class scores, [N x K]
  hidden_layer = np.maximum(0, np.dot(X, W) + b) # note, ReLU activation
  scores = np.dot(hidden_layer, W2) + b2

  # compute the class probabilities
  exp_scores = np.exp(scores)
  probs = exp_scores / np.sum(exp_scores, axis=1, keepdims=True) # [N x K]
  
  # compute the loss: average cross-entropy loss and regularization
  corect_logprobs = -np.log(probs[range(num_examples),y])
  data_loss = np.sum(corect_logprobs)/num_examples
  reg_loss = 0.5*reg*np.sum(W*W) + 0.5*reg*np.sum(W2*W2)
  loss = data_loss + reg_loss
  
  predicted_class = np.argmax(scores, axis=1)
  f.write("%d: %f %.4f" % (i, loss,np.mean(predicted_class == y))+'\n')
  
  if loss<max([m[0] for m in minLoss]): 
      minLoss.append([loss,i,np.copy(W),np.copy(b),np.copy(W2),np.copy(b2)])
      minLoss.sort(compare)
      minLoss = minLoss[:-1]

  if i % 10 == 0:
    l = [round(k[0],4) for k in minLoss]
    #print 'iteration:',i,' ',loss,' ',l
    predicted_class = np.argmax(scores, axis=1)
    print "iteration %d: loss %f accuracy %.4f" % (i, loss, np.mean(predicted_class == y))
    
    #print('training accuracy: %.4f' % (np.mean(predicted_class == y)))
      
  # compute the gradient on scores
  dscores = probs
  dscores[range(num_examples),y] -= 1
  dscores /= num_examples
  
  # backpropate the gradient to the parameters
  # first backprop into parameters W2 and b2
  dW2 = np.dot(hidden_layer.T, dscores)
  db2 = np.sum(dscores, axis=0, keepdims=True)
  # next backprop into hidden layer
  dhidden = np.dot(dscores, W2.T)
  # backprop the ReLU non-linearity
  dhidden[hidden_layer <= 0] = 0

  # finally into W,b
  dW = np.dot(X.T, dhidden)
  db = np.sum(dhidden, axis=0, keepdims=True)
  
  # add regularization gradient contribution
  dW2 += reg * W2
  dW += reg * W
  
  # perform a parameter update
  W += -step_size * dW
  b += -step_size * db
  W2 += -step_size * dW2
  b2 += -step_size * db2
  
  
# evaluate training set accuracy
hidden_layer = np.maximum(0, np.dot(X, W) + b)
scores = np.dot(hidden_layer, W2) + b2
predicted_class = np.argmax(scores, axis=1)
print('training accuracy: %.2f' % (np.mean(predicted_class == y)))


for m in minLoss:
  folder = str(m[1]) + ' - ' + str(m[0]) +'/'
  os.mkdir(folder)
  np.save(folder + 'W', m[2])
  np.save(folder + 'b', m[3])
  np.save(folder + 'W2', m[4])
  np.save(folder + 'b2', m[5])


f.close()








"""
neurons = 30
epoch = 30
batch_size = 10 #à modifier aussi
learning_rate = 3.0
version = 0

for n in [15]:  #[15,30,50,70,100]
    neurons = n
    
    for l in range(2): # -3,2 -1,2
        learning_rate = pow(10., l)

        for v in range(1):
            version = v
        
            folder = str(neurons)+'n '+ str(epoch) +'e ' + str(batch_size) + 'b ' + '%.0E' % Decimal(str(learning_rate)) + ' (' + str(version) + ')/' 
            os.mkdir(folder)
            
            print 'new network : ' + folder[:-1]
            net = network.Network([784, neurons, 10])
            net.SGD(training_data, epoch, batch_size, learning_rate, test_data=test_data, folder=folder)
            
            w = net.weights
            b = net.biases
            
            np.save(folder + 'w', w)
            np.save(folder + 'b', b)
            
            print 'save !'
            print
            
"""