# -*- coding: utf-8 -*-
"""
Created on Sun Jan 29 09:18:39 2017

@author: Xavier
"""

import numpy as np

w = [[1],[2],[2],[3]]

w = np.array(w)

np.save('w1',w)

print np.load('w1.npy')

