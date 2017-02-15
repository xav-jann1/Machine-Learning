# -*- coding: utf-8 -*-
"""
Created on Sun Jan 29 14:31:42 2017

@author: Xavier
"""

import os
from decimal import Decimal
import mnist_loader, network, numpy as np


print 'load data..'
training_data, validation_data, test_data = mnist_loader.load_data_wrapper()
print 'data loaded !' + '\n'

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
            
            
            
