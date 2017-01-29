# -*- coding: utf-8 -*-
"""
Created on Sat Jan 28 15:40:00 2017

@author: Xavier
"""
from random import randrange, shuffle


X = []
for i in range(100):
    X.append([randrange(0,1000,2)])    #Pair
    X.append([randrange(1,1000,2)])    #Impair

print(X)
shuffle(X)
print()
print(X)

y = []
for n in X:
    if n[0]%2 == 0:
        y.append(0)
    else:
        y.append(1)
    
print(y)