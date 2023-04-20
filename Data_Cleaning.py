# -*- coding: utf-8 -*-
"""
Created on Wed Apr 19 14:22:18 2023

@author: marvi
"""

import pandas as pd

'This makes sure the directory is only this//not working right now :('

'So here I will clean the data by grouping the comparables and all their columns'
'I will also attempt to try to group the data by neighborhood'

'First call the excel file using the pandas library'
data = pd.read_excel("C:\\Users\\marvi\\OneDrive\\Documents\\GitHub\\Quant_R_Python\\Cleaned_Condo_Data.xlsx")
print(data)

'Make a function that wrangles the columns that have numeric values and groups or aggregates by neighborhood'