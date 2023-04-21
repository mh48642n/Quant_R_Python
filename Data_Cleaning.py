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
data = "C:\\Users\\marvi\\OneDrive\\Documents\\GitHub\\Quant_R_Python\\Cleaned_Condo_Data.xlsx"
data = pd.read_excel(data)


'This function determines the columns that can be grouped together by type and their column names'
'So the output of this function should be the dataframe with a key that corresponds to columns' 
'with values of type = float64'
def filter_out(data):
    type_dict = {}
    mytype = 'float64'
    dtypes = data.dtypes.to_dict()
    x = 1
    
    for col_name, typ in dtypes.items():
        if(typ != mytype):
            continue
        else:
            type_dict[x] = col_name
            x+=1
    return type_dict
def columns_set(clean_data, data):
    for column in data: 
        if("Gross Income per"):
            print("Income per")
        if(column.contains("Estimated Expense")):
            print("E Expense")
        if(column.contains("Expense per")):
            print("Per")
        if(column.contains("Full Market")):
            print("F Market")
        if(column.contains("Market Value per")):
            print("M Value per")
        
    

'This function works!!!' 
'This list out all the columns names with key values so if I want to access these values individually'
'I can do that and I can also make this into a dataframe'                       
'clean_data = pd.DataFrame(pd.Series(filter_out(data))).T'
clean_data = filter_out(data)
clean_data = pd.DataFrame(clean_data.items(), columns=['Key', 'Name of Column'])

columns_set(clean_data, data)



'Make a function that wrangles the columns that have numeric values and groups or aggregates by neighborhood'