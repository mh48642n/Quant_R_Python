# -*- coding: utf-8 -*-
"""
Created on Thu Apr  6 14:11:52 2023

@author: marvi
"""

import os as os

#this gets my current working directory
os.getcwd()

#This finds the path and if it exists on this device
path = "C:/Users/marvi/OneDrive/Documents/Quant_Stat_Programming"
isExist = os.path.exists(path)
print(isExist)

#this changes the working directory to this
os.chdir(path)
