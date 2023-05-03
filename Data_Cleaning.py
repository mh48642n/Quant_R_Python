# -*- coding: utf-8 -*-
"""
Created on Wed Apr 19 14:22:18 2023

@author: marvi
"""

import pandas as pd
import re


'So here I will clean the data by grouping the comparables and all their columns'
'I will also attempt to try to group the data by neighborhood'

'First call the excel file using the pandas library'
data = "C:\\Users\\marvi\\OneDrive\\Documents\\GitHub\\Quant_R_Python\\Cleaned_Condo_Data.xlsx"
data = pd.read_excel(data)
data1 = data


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
def regextolist(data, columns): 
   'First we define the pattern we are looking for with exp that will be taken as an input'
     
   """ Patterns:
       Total Units:             Total Units.\d
       Gross Sqft:              Gross SqFt.\d
       Estimated Gross Incomes: .*Gross Income.\d
       Gross Income per SqFt:   .*Income per SqFt.\d
       Estimated Expense:       .*Expense.\d
       Expense per Sqft:        Expense.*\d
       Net:                     \AN.*.\d 
       Full Market Value:       .*Value.\d
       Market Value per Sqft:   ^M.*.*.*\d$
       """ 
   """ Patterns Works
       Works in loop for all patterns
       r0 = re.compile("Gross SqFt.\d")
       gsqft = list(filter(r0.match, columns))
       print("Gross Sqft:", gsqft)
      """
    
   list_col = ["comp_avgstu", "comp_avggsft", "comp_avgginc", "comp_avggips", "comp_avgexp", 
               "comp_avgeps", "comp_avgnet", "comp_avgfmv","comp_avgmvps"]
   list_reg = ["Total Units.\d", "Gross SqFt.\d", ".*Gross Income.\d", ".*Income per SqFt.\d", ".*Expense.\d",
               "Expense.*\d", "\AN.*.\d", ".*Value.\d", "^M.*.*.*\d$"]
   'This loop will grab the data then group by the columns as an average' 
   y = 0
   while(y != 9):
       'Creates the regex that will help find the columns that match the pattern'
       'col_n is the list of all the values that fit the pattern'
       r = re.compile(list_reg[y])
       col_n = list(filter(r.match, columns))
       
       'This collapse the columns that are in col_n and averages them'
       x = data[col_n].aggregate(["mean"], axis = 1, skipna = False).round()    
       print(x)
       
       'Makes a new column and makes it part of the new data object'
       new_col = list_col[y]
       data[new_col] = x
       
       if(y == (1|2|4|6|7)):
           data[new_col] = data[new_col].div(10**6).round(2)
       
       y+=1
   
   list(data.columns) 
   print(data)
   return data
   
'This function works!!!!' 
'This list out all the columns names with key values so if I want to access these values individually'
'I can do that and I can also make this into a dataframe'                       
clean_data = filter_out(data)
clean_data = pd.DataFrame(clean_data.items(), columns=['Key', 'Name of Column'])
columns = clean_data['Name of Column'].values.tolist()


'Make a function that wrangles the columns that have numeric values and groups or aggregates by neighborhood'
data1 = regextolist(data1, columns)

'Eliminates columns that have no number values'
data1.drop(["Boro-Block-Lot", "Borough_ID", "Borough"], axis = 1) 

'Eliminates any remaining columns that have numbered values'
data1 = data1.drop(data1.filter(regex = '\d$'), axis = 1)    

'Groups the data by Neighborhood which are averages for each column'
data1 = data1.groupby('Neighborhood').aggregate(["mean"], skipna = False).round(2)
data1.columns.droplevel(1)

data1.to_excel("C:\\Users\\marvi\\OneDrive\\Documents\\GitHub\\Quant_R_Python\\Cleaned_Condo_Data.xlsx")

'del clean_data, columns, data, data1'

