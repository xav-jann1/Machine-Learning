# -*- coding: utf-8 -*-
"""
Created on Sun Jan 29 14:31:42 2017

@author: Xavier
"""

import os
from decimal import Decimal
import mnist_loader, network, numpy as np


training_data, validation_data, test_data = mnist_loader.load_data_wrapper()

neurons = 30
epoch = 2
batch_size = 10
learning_rate = 3.0
version = 1

folder = str(30)+'n '+ str(epoch) +'e ' + str(batch_size) + 'b ' + '%.0E' % Decimal(str(learning_rate)) + ' (' + str(version) + ')/' 
os.mkdir(folder)

net = network.Network([784, neurons, 10])
net.SGD(training_data, epoch, batch_size, learning_rate, test_data=test_data, folder=folder)

w = net.weights
b = net.biases

np.save(folder + 'w', w)
np.save(folder + 'b', b)





