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


"""
#np.savetxt('w.gz',w)
f = open('w.gz')
np.loadtxt(f)


fo = open("foo.txt", "w")

print w

fo.write(""+str(w))

print "Read String is : "
# Close opend file
fo.close()"""