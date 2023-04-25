# -*- coding: utf-8 -*-
"""
Created on Wed Apr 19 14:22:18 2023

@author: marvi
"""

import pandas as pd
import numpy as np
import re


'This makes sure the directory is only this//not working right now :('

'So here I will clean the data by grouping the comparables and all their columns'
'I will also attempt to try to group the data by neighborhood'

'First call the excel file using the pandas library'
data = "C:\\Users\\marvi\\OneDrive\\Documents\\GitHub\\Quant_R_Python\\Cleaned_Condo_Data.xlsx"
data = pd.read_excel(data)

'This prints out the datatypes for all columns in the object called data'
print(data.dtypes)

'So the output of this function should be the dataframe with a key that corresponds to columns' 
'with values of type = float64. Also it will account for certain columns that are int64'
def filter_out(data):
    type_dict = {}
    mytype = 'float64'
    dtypes = data.dtypes.to_dict()
    x = 1
    
    for col_name, typ in dtypes.items():
        if(typ == 'int64'):
            if "_" in col_name:
               continue
            else:
                type_dict[x] = col_name
                x+=1
        elif(typ == mytype):
            type_dict[x] = col_name
            x+=1
        else:
            continue
    return type_dict
def regextolist(columns): 
   'First we define the pattern we are looking for with exp that will be taken as an input'
   'Works'
   r0 = re.compile("Gross SqFt.\d")
   gsqft = list(filter(r0.match, columns))
   print("Gross Sqft:", gsqft)
   
   'Works'
   r1 = re.compile(".*Expense.\d")
   'r1 = re.compile(input(".*Expense.\d"))'
   expenselist = list(filter(r1.match, columns))
   print("Estimated Expense:" ,expenselist)
   
   'Works'
   r2 = re.compile("Expense.*\d")
   epsqft = list(filter(r2.match, columns))
   print("Expense per Sqft:",epsqft)
   
   'Works'
   r3 = re.compile(".*Gross Income.\d")
   egross = list(filter(r3.match, columns))
   print("Estimated Gross Incomes:", egross)
   
   'Works'
   r4 = re.compile("(\AN.*.\d)")
   netop = list(filter(r4.match, columns))
   print("Net: ",netop)
   
   'Works'
   r5 = re.compile("Total Units.\d")
   tu1 = list(filter(r5.match, columns))
   print("TU", tu1)
   
   'Works'
   r6 = re.compile(".*Income per SqFt.\d")
   gips = list(filter(r6.match, columns))
   print("Gross Income per SqFt:", gips)
   
   'Works'
   r7 = re.compile(".*Value.\d")
   fmv = list(filter(r7.match, columns))
   print("Full Market Value:", fmv)
   
   'Works'
   r8 = re.compile("^M.*.*.*\d$")
   mvps = list(filter(r8.match, columns))
   print("Market Value per Sqft:", mvps)
   
   'Now I will put this in a while loop and iterate through each using the phrases discovered for the patterns'
   'Make use of split-apply-merge methodology'
   'Take out the rows that I need, make it a dataframe, apply aggregate function(mean), join the new column back'
   """Patterns:
       Total Units:             Total Units.\d
       Gross Sqft:              Gross SqFt.\d
       Estimated Gross Incomes: .*Gross Income.\d
       Gross Income per SqFt:   .*Income per SqFt.\d
       Estimated Expense:       .*Expense.\d
       Expense per Sqft:        Expense.*\d
       Full Market Value:       .*Value.\d
       Market Value per Sqft:   ^M.*.*.*\d$
       Net:                     (\AN.*.\d) 
       """ 

'This function works!!!' 
'This list out all the columns names with key values so if I want to access these values individually'
'I can do that and I can also make this into a dataframe'                       
'clean_data = pd.DataFrame(pd.Series(filter_out(data))).T'
clean_data = filter_out(data)
clean_data = pd.DataFrame(clean_data.items(), columns=['Key', 'Name of Column'])
columns = clean_data['Name of Column'].values.tolist()
'This creates a series out of the Name of Column variable in the clean_data object'
columns = pd.Series(clean_data['Name of Column'])
print(clean_data)


'Both of these work, it will get complicated to '
columns[columns.str.match(r'(^G.*)') == True]
'Has gross income per sqft and gross sqft for just comparables'
gross = columns[columns.str.match(r'(\AG.*.\d)') == True]
'Has Full Market Values for just comparables'
full_market = columns[columns.str.match(r'(\AF.*.\d)') == True]
'Has estimated gross income, estimated expense and expense per sqft for just comparables'
estimated = columns[columns.str.match(r'(\AE.*.\d)') == True]
'Has net incomes for the comparables'
net = columns[columns.str.match(r'(\AN.*.\d)') == True]

print(net)
print(gross)
print(full_market)
print(estimated)

regextolist(columns)

'Make a function that wrangles the columns that have numeric values and groups or aggregates by neighborhood'