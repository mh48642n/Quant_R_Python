# -*- coding: utf-8 -*-
"""
Created on Thu Apr  6 14:11:52 2023

@author: marvi
"""

import os as os

#this gets my current working directory
def stuff():
    os.getcwd()

    #This finds the path and if it exists on this device
    #If this is being run on another device just insert the new path and it should work
    path = "C:/Users/marvi/OneDrive/Documents/GitHub/Quant_R_Python"
    isExist = os.path.exists(path)
    print(isExist)

    #this changes the working directory to this
    os.chdir(path)

stuff()