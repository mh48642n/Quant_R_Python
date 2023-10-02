# -*- coding: utf-8 -*-
"""
Created on Mon Aug 21 17:10:05 2023

@author: marvi
"""

import openpyxl as op
import pandas as pd
import pyexcel as p

def menu():
    print("Data wrangling with Python\n")
    answer = input("""For Merging: \n\tPress 1 
                   \nFor joining individual columns \n\tPress 2  
                   \nFor changing xls file to xlsx file \n\tPress 3
                   \nF\nAnswer: """)
    
    return answer
    
#this function assumes that any columns added are all of the same length
#And have each of the datasets on a sheet with the same name
def addingToDict(col_name, col_index):
    print("\n\nWhat is the range of these datasets(all have to be the same)")
    begin = int(input("\tBeginning: "))
    end = int(input("\tEnding on: ")) + 1
    sheetName = input("Sheet name: ")
    
    value_dict = {}
    
    columns = int(input("How many columns are you adding: "))
   
    while columns > 0:
        
        data = findingColumns(col_index, begin, end, sheetName)
        if(col_name != "dates"):
            data = pd.Series(data)
            data = data.apply(pd.to_numeric, errors = 'coerce')  
            
        value_dict[col_name] = data
        
        columns -= 1
        if(columns != 0):
            print("\tColumns left: ", columns)
            
            col_name = input("\nWhat you want new column to be named in file A: ")
            col_index = int(input("Index of the column being read(column A = 1): "))
            continue
        else:
            answer = input("Are you adding another column T/F: ")
            if(answer == "F"):
                columns == -1
            else:
                columns += 1
                col_name = input("\nWhat you want new column to be named in file A: ")
                col_index = int(input("Index of the column being read(column A = 1): "))
                continue
      

        
    dataset = pd.DataFrame(value_dict)
    return dataset
    
def findingColumns(col_index, begin, end, sheetName):
    fileName = input("\nFile(path)that you want join columns from: ")
    
    
    bk = op.load_workbook(fileName) 
    bk.active = bk[sheetName]
    sheet = bk.active
    
    #compiles data into list to be stored in a range 
    data = [sheet.cell(row = i, column = col_index).value for i in range(begin, end)]
    bk.close()
    
    return data
def mergingtables():
    left = pd.read_excel(input("\n\tLeft: "), sheet_name = "Sheet 1")
    right = pd.read_excel(input("\tRight: "), sheet_name = "Sheet 1")
    
    howto = input("\n\tJoin how?(left, right, inner, outer):")
    onwhat = input("\tJoin on what column: ")
    
    merge = pd.merge(left, right, how = howto, on = onwhat, sort = True)
    return merge
def convert_files():
    p.save_book_as(file_name = input("Name of path with double backslashes: "),
                   dest_file_name = input("Name of new path woth double backslashes: "))



answer = int(menu())    

match answer: 
    case 1:
        print("Welcome to the file_merger")
        cond = "Yes" 
        
        while(cond == "Yes"):
            merge = mergingtables()
            merge.to_excel(input("Name of new file(.xlsx or .xls): "), sheet_name = "Sheet 1", index = False)
            cond = input("Continue merging, Yes or No: ")
            merge = None
    case 2:
        print("Welcome to the column_joiner")
        file = input("New file name(.xlsx or .xls): ")
        col_name = input("\nWhat you want new column to be named in the new excel workbook: ")
        col_index = int(input("Index of the column being read(so column A is 1):"))    
        
        data = addingToDict(col_name, col_index)
        data.to_excel(file, sheet_name = "Sheet 1", index = False)
        data = None
    case 3: 
        print("This is file converter, only for xls to xlsx!!!")
        convert_files()

print("Have fun analyzing this data!!!!")
    
    



