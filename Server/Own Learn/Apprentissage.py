# -*- coding: utf-8 -*-
"""
Created on Sun Jan 29 14:31:42 2017
@author: Xavier

Sources :
- http://cs231n.github.io/neural-networks-case-study/
- http://neuralnetworksanddeeplearning.com/chap1.html
"""

import numpy as np

import cPickle
import gzip

def load_data():
    f = gzip.open('data/mnist.pkl.gz', 'rb') #Telecharger fichier : https://github.com/mnielsen/neural-networks-and-deep-learning/raw/master/data/mnist.pkl.gz
    training_data, validation_data, test_data = cPickle.load(f)
    f.close()
    return (training_data, test_data)


N = 500 # number of points per class
D = 784 # dimensionality
K = 10 # number of classes

print 'load data..'
training_data, test_data = load_data()

X = training_data[0]
y = training_data[1]

print 'data loaded !' + '\n'


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
